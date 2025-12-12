function [results] = Copy_of_simulateVehicleDynamics(params, accel, timeParams)
%% SIMULATEVEHICLEDYNAMICS - Simulates roll and pitch dynamics including suspension effects
%

% params.mass = 1500;
% params.track_width = 1.6;
% params.wheelbase = 2.6;
% params.h_cg = 0.55;
% params.l_f = 1.2;
% params.l_r = 1.4;
% params.Ixx = 600;
% params.Iyy = 1500;
% 
% params.roll_stiffness_spring = 30000; % Nm/rad
% params.roll_stiffness_ARB = 10000; % Nm/rad
% params.roll_damping = 2500; % Nm/(rad/s)
% 
% params.pitch_stiffness_spring = 40000; % Nm/rad
% params.pitch_damping = 3000; % Nm/(rad/s)
% 
% params.h_rc_front0 = 0.15;
% params.h_rc_rear0 = 0.20;
% params.h_pc_front0 = 0.15;
% params.h_pc_rear0 = 0.20;
% 
% params.k_rf = 0.05;
% params.k_rr = 0.05;
% params.k_pf = 0.04;
% params.k_pr = 0.04;

% Inputs:
%   params: struct containing vehicle and suspension parameters.
%   accel: struct containing acceleration inputs (ax, ay, az).
%   timeParams: struct containing time parameters (dt, tFinal).
%
% Outputs:
%   results: struct containing time history of vehicle dynamic responses.

%% Time setup
dt = timeParams.dt;
t = 0:dt:timeParams.tFinal;
n = length(t);

% Initialize acceleration vectors
ax = expandSignal(accel, 'ax', t, 0);
ay = expandSignal(accel, 'ay', t, 0);
az = expandSignal(accel, 'az', t, 9.81); % default gravity

%% Initialize state variables
roll_angle = zeros(1, n);
pitch_angle = zeros(1, n);
roll_rate = zeros(1, n);
pitch_rate = zeros(1, n);
h_rc_front = zeros(1, n);
h_rc_rear = zeros(1, n);
h_pc_front = zeros(1, n);
h_pc_rear = zeros(1, n);
roll_mom = zeros(1, n);
pitch_mom = zeros(1, n);

% New advanced dynamics variables
lat_load_transfer = zeros(1, n);
long_load_transfer = zeros(1, n);
Fz_front = zeros(1, n);
Fz_rear = zeros(1, n);
Fz_FL = zeros(1, n);
Fz_FR = zeros(1, n);
Fz_RL = zeros(1, n);
Fz_RR = zeros(1, n);
roll_acc_array = zeros(1, n);
pitch_acc_array = zeros(1, n);
sprung_az = zeros(1, n);
body_slip_angle = zeros(1, n);

% Initial conditions
h_rc_front(1) = params.h_rc_front0;
h_rc_rear(1) = params.h_rc_rear0;
h_pc_front(1) = params.h_pc_front0;
h_pc_rear(1) = params.h_pc_rear0;

%% Suspension effective stiffnesses
k_roll_total = params.roll_stiffness_spring + params.roll_stiffness_ARB; % Roll stiffness from springs + ARBs
k_pitch_total = params.pitch_stiffness_spring; % Assume ARBs don't affect pitch much

%% Main simulation loop
for i = 2:n
    % Update roll centers
    h_rc_front(i) = params.h_rc_front0 - params.k_rf * tan(roll_angle(i-1));
    h_rc_rear(i) = params.h_rc_rear0 - params.k_rr * tan(roll_angle(i-1));
    h_roll = params.h_cg - (h_rc_front(i) + h_rc_rear(i)) / 2;
    
    % Roll dynamics
    M_roll = params.mass * ay(i) * h_roll;
    roll_acc = (M_roll - k_roll_total * roll_angle(i-1) - params.roll_damping * roll_rate(i-1)) / params.Ixx;
    roll_rate(i) = roll_rate(i-1) + roll_acc * dt;
    roll_angle(i) = roll_angle(i-1) + roll_rate(i) * dt;
    roll_mom(i) = M_roll;
    roll_acc_array(i) = roll_acc;

    % Update pitch centers
    h_pc_front(i) = params.h_pc_front0 - params.k_pf * tan(pitch_angle(i-1));
    h_pc_rear(i) = params.h_pc_rear0 - params.k_pr * tan(pitch_angle(i-1));
    h_pitch = params.h_cg - (h_pc_front(i) + h_pc_rear(i)) / 2;
    
    % Pitch dynamics
    M_pitch = params.mass * ax(i) * h_pitch;
    pitch_acc = (M_pitch - k_pitch_total * pitch_angle(i-1) - params.pitch_damping * pitch_rate(i-1)) / params.Iyy;
    pitch_rate(i) = pitch_rate(i-1) + pitch_acc * dt;
    pitch_angle(i) = pitch_angle(i-1) + pitch_rate(i) * dt;
    pitch_mom(i) = M_pitch;
    pitch_acc_array(i) = pitch_acc;

    % Advanced dynamics calculations
    lat_load_transfer(i) = (params.mass * ay(i) * h_roll) / params.track_width;
    long_load_transfer(i) = (params.mass * ax(i) * params.h_cg) / params.wheelbase;

    Fz_static = params.mass * 9.81 / 2;
    Fz_front(i) = Fz_static - long_load_transfer(i)/2;
    Fz_rear(i)  = Fz_static + long_load_transfer(i)/2;

    Fz_FL(i) = (Fz_front(i)/2) + (lat_load_transfer(i)/2);
    Fz_FR(i) = (Fz_front(i)/2) - (lat_load_transfer(i)/2);
    Fz_RL(i) = (Fz_rear(i)/2) + (lat_load_transfer(i)/2);
    Fz_RR(i) = (Fz_rear(i)/2) - (lat_load_transfer(i)/2);

    sprung_az(i) = az(i) - (roll_acc * h_roll + pitch_acc * params.h_cg) / sqrt(params.Ixx^2 + params.Iyy^2);
    body_slip_angle(i) = atan2(ay(i), ax(i));
end

%% Convert angles to degrees
roll_angle_deg = rad2deg(roll_angle);
pitch_angle_deg = rad2deg(pitch_angle);

%% Package results
results = struct();
results.t = t;
% results.roll_angle = roll_angle;
% results.pitch_angle = pitch_angle;
results.roll_angle_deg = roll_angle_deg;
results.pitch_angle_deg = pitch_angle_deg;
results.roll_rate = roll_rate;
results.pitch_rate = pitch_rate;
results.roll_mom = roll_mom;
results.pitch_mom = pitch_mom;
results.h_rc_front = h_rc_front;
results.h_rc_rear = h_rc_rear;
results.h_pc_front = h_pc_front;
results.h_pc_rear = h_pc_rear;

% New outputs
results.lat_load_transfer = lat_load_transfer;
results.long_load_transfer = long_load_transfer;
results.Fz_front = Fz_front;
results.Fz_rear = Fz_rear;
results.Fz_FL = Fz_FL;
results.Fz_FR = Fz_FR;
results.Fz_RL = Fz_RL;
results.Fz_RR = Fz_RR;
results.roll_acc = roll_acc_array;
results.pitch_acc = pitch_acc_array;
results.sprung_az = sprung_az;
results.body_slip_angle = body_slip_angle;

if nargout == 0
    plotResults(results);
end
end

%% Helper Functions
function signal = expandSignal(accelStruct, fieldName, t, defaultVal)
% Expand or interpolate signal to match time vector
n = length(t);
if isfield(accelStruct, fieldName)
    sig = accelStruct.(fieldName);
    if isscalar(sig)
        signal = sig * ones(1, n);
    elseif length(sig) == n
        signal = sig;
    else
        signal = interp1(linspace(0, t(end), length(sig)), sig, t, 'linear', 'extrap');
    end
else
    signal = defaultVal * ones(1, n);
end
end

function plotResults(results)
% Basic Plotting of Main Outputs
figure;
subplot(3,1,1);
plot(results.t, results.roll_angle_deg, 'b', results.t, results.pitch_angle_deg, 'r', 'LineWidth', 1.5);
title('Roll and Pitch Angles'); ylabel('Angle [deg]'); legend('Roll','Pitch'); grid on;

subplot(3,1,2);
plot(results.t, results.roll_rate, 'b', results.t, results.pitch_rate, 'r', 'LineWidth', 1.5);
title('Roll and Pitch Rates'); ylabel('Rate [rad/s]'); legend('Roll Rate','Pitch Rate'); grid on;

subplot(3,1,3);
plot(results.t, results.roll_mom, 'b', results.t, results.pitch_mom, 'r', 'LineWidth', 1.5);
title('Roll and Pitch Moments'); ylabel('Moment [Nm]'); xlabel('Time [s]'); legend('Roll Moment','Pitch Moment'); grid on;
end
