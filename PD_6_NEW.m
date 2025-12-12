
%% Initialization
clear all; close all; clc;
addpath(genpath(pwd));

%% User Configuration Section
% ============================================================
% SECTION 1: FILE PATHS AND NAMES
% ============================================================
inputFiles.carDataFile = 'CarData_FST12_pDynamics_V1';  % Base vehicle parameters
inputFiles.excelFile = 'CarData.xlsx';                 % Excel file with parameters
outputFiles.resultsFile = 'data_gen\simulation_results_1.mat'; % Output file
baseVehicle =vdl_read_Params(inputFiles.carDataFile,'','','');
% ============================================================
% SECTION 2: SUSPENSION PARAMETER RANGES
% ============================================================
% Front suspension parameters
frontSusp.springStiffnessRange = [40e3, 69e3]; % [min, max] in N/m
frontSusp.ARBStiffnessRange = [1853, 2500];   % [min, max] in N.m/degree
frontSusp.wheelTravel = 5;                     % Wheel travel in mm
frontSusp.motionRatio = 1.3158;                % Front motion ratio

% Rear suspension parameters
rearSusp.springStiffnessRange = [50e3, 63e3];  % [min, max] in N/m
rearSusp.ARBStiffnessRange = [1930, 2500];       % [min, max] in N.m/degree
rearSusp.wheelTravel = 5;                      % Wheel travel in mm
rearSusp.motionRatio = 1.25;                   % Rear motion ratio

% ============================================================
% SECTION 3: VEHICLE GEOMETRY
% ============================================================
geometry.rollCenterFront = [0.045, 0.060, 0.037]; % Front roll center positions (m)
geometry.rollCenterRear = 0.07;                   % Rear roll center position (m)
geometry.pitchCenterFront = 0.0669;               % Front pitch center height (m)
geometry.pitchCenterRear = 0.0808;                % Rear pitch center height (m)
geometry.pitchCenterXFront = 0.72504;             % X-distance from front axle (m)
geometry.pitchCenterXRear = 0.671;                % X-distance from front axle (m)

% ============================================================
% SECTION 4: TEST CONDITIONS
% ============================================================
testConditions.lateralAcceleration = 5;    % Lateral acceleration (m/s²)
testConditions.longitudinalAcceleration = 1; % Longitudinal acceleration (m/s²)
testConditions.velocity = 10;              % Velocity (m/s)

% ============================================================
% SECTION 5: SIMULATION SETTINGS
% ============================================================
simSettings.numSpringStepsFront = 6;       % Number of front spring steps
simSettings.numSpringStepsRear = 4;        % Number of rear spring steps
simSettings.numARBSteps = 6;               % Number of ARB stiffness steps
simSettings.ARBPositionsFront = [0, 1, 2]; % Front ARB position options
simSettings.ARBPositionsRear = [0:5];      % Rear ARB position options
simSettings.showProgress = true;           % Display progress during simulation

%% % Motion ratios for anti-roll bars (measured from CAD)
% Front ARB motion ratios for each position
advancedConfig.MR_ARB_ft = [
    mean([0,0,0,0,0,0,0,0,0,0]);
    mean([0.0697,0.0757,0.0806,0.0836,0.0842,0.0868,0.0910,0.0982,0.1024,0.1081]); 
    mean([0.044,0.046,0.048,0.049,0.05,0.051,0.052,0.052,0.053,0.054]);
];

% Rear ARB motion ratios for each position
advancedConfig.MR_ARB_rr = [  
    mean([0,0,0,0,0,0,0,0,0,0]);
    mean([0.339,0.362,0.389,0.422,0.461,0.572,0.655,0.773,0.95,1.253]);
    mean([0.268,0.284,0.301,0.321,0.345,0.407,0.45,0.506,0.58,0.687]);
    mean([0.21,0.221,0.232,0.245,0.26,0.296,0.32,0.348,0.384,0.431]);
    mean([0.162,0.17,0.177,0.185,0.195,0.216,0.229,0.244,0.263,0.285]);
    mean([0.122,0.127,0.132,0.137,0.143,0.149,0.163,0.171,0.18,0.191]);
];

%% Main Execution
% ============================================================
% SECTION 6: DATA PROCESSING AND SIMULATION
% ============================================================

% Load base vehicle parameters
vehicleConfig = baseVehicle; % Extracted suspension values 

%% Import Car Parameter Data
[~,~,raw] = xlsread('CarData.xlsx','Parameters');
[Structs] = ProcessParameterData(raw,{'Car','Aero','Sus'});
Car = Structs.Car;
Aero = Structs.Aero;
Sus = Structs.Sus;
clear Structs;

% Generate parameter ranges
RS_ARB_ft = linspace(frontSusp.ARBStiffnessRange(1), frontSusp.ARBStiffnessRange(2), simSettings.numARBSteps) * pi/180;
RS_ARB_rr = linspace(rearSusp.ARBStiffnessRange(1), rearSusp.ARBStiffnessRange(2), simSettings.numARBSteps) * pi/180;
RS_Spring_ft = linspace(frontSusp.springStiffnessRange(1), frontSusp.springStiffnessRange(2), simSettings.numSpringStepsFront);
RS_Spring_rr = linspace(rearSusp.springStiffnessRange(1), rearSusp.springStiffnessRange(2), simSettings.numSpringStepsRear);

% Store configuration
config = storeInStructure(geometry.rollCenterFront, geometry.rollCenterRear, ...
    testConditions.lateralAcceleration, testConditions.longitudinalAcceleration, ...
    testConditions.velocity, RS_Spring_rr, RS_Spring_ft, rearSusp.motionRatio, ...
    advancedConfig.MR_ARB_rr, frontSusp.motionRatio, advancedConfig.MR_ARB_ft, ...
    RS_ARB_ft, RS_ARB_rr, simSettings.ARBPositionsFront, simSettings.ARBPositionsRear, ...
    frontSusp.wheelTravel, rearSusp.wheelTravel);

metadata.config = config;

% Create parameter grid for simulation
[A, B, E, F, G, T, S, R, H, Y, P, Z, X, I, O] = ndgrid(...
    1:length(RS_ARB_ft), 1:length(RS_ARB_rr), 1:length(geometry.rollCenterFront), ...
    1:length(geometry.rollCenterRear), 1:length(RS_Spring_ft), 1:length(RS_Spring_rr), ...
    1:length(geometry.pitchCenterFront), 1:length(geometry.pitchCenterRear), ...
    1:length(testConditions.velocity), 1:length(testConditions.lateralAcceleration), ...
    1:length(testConditions.longitudinalAcceleration), 1:length(simSettings.ARBPositionsFront), ...
    1:length(simSettings.ARBPositionsRear), 1:length(geometry.pitchCenterXFront), ...
    1:length(geometry.pitchCenterXRear));

[C,D] = ndgrid(1:length(frontSusp.wheelTravel), 1:length(rearSusp.wheelTravel));
simsWT = numel(C);

% Preallocate results
totalSims = numel(A);
results = zeros(totalSims, 29);
simResultsCell = cell(totalSims, 1);
vehicleConfig = baseVehicle;

fprintf('Total number of simulations: %d\n', totalSims);

% Main simulation loop
for idx = 1:totalSims
    % Extract parameter indices
    a = A(idx); b = B(idx); e = E(idx); f = F(idx); g = G(idx); 
    t = T(idx); p = P(idx); s = S(idx); r = R(idx); h = H(idx); 
    y = Y(idx); x = X(idx); z = Z(idx); i = I(idx); o = O(idx);
    
    % Update vehicle configuration
    vehicleConfig.RS_ARB_ft = RS_ARB_ft(a);
    vehicleConfig.RS_ARB_rr = RS_ARB_rr(b);
    vehicleConfig.RS_Spring_ft = RS_Spring_ft(g);
    vehicleConfig.RS_Spring_rr = RS_Spring_rr(t);
    vehicleConfig.RC_ft = geometry.rollCenterFront(e);
    vehicleConfig.RC_rr = geometry.rollCenterRear(f);
    vehicleConfig.PC_ft = geometry.pitchCenterFront(s);
    vehicleConfig.PCx_ft = geometry.pitchCenterXFront(i);
    vehicleConfig.PC_rr = geometry.pitchCenterRear(r);
    vehicleConfig.PCx_rr = geometry.pitchCenterXRear(o);
    
    % Calculate pitch center height
    pc_height = (vehicleConfig.PC_ft * vehicleConfig.a + ...
                vehicleConfig.PC_rr * vehicleConfig.b) / vehicleConfig.WB;
    vehicleConfig.hPC = pc_height;
    
    % Wheel travel simulation
    PG = zeros(simsWT,1); RG = zeros(simsWT,1); LLD_ft = zeros(simsWT,1);
    RSD = zeros(simsWT,1); NF_f = zeros(simsWT,1); NF_r = zeros(simsWT,1);
    HR = zeros(simsWT,1); totalRollStiffness = zeros(simsWT,1);
    WR_ft = zeros(simsWT,1); WR_rr = zeros(simsWT,1);
    
    for jdx = 1:simsWT
        c = C(jdx); d = D(jdx);
        
        vehicleConfig.MR_ft = frontSusp.motionRatio(c);
        vehicleConfig.MR_ARB_ft = advancedConfig.MR_ARB_ft(z,c);
        vehicleConfig.MR_ARB_rr = advancedConfig.MR_ARB_rr(x,d);
        vehicleConfig.MR_rr = rearSusp.motionRatio(d);
        
        % Perform calculations
        [pitchMoment, rollMoment] = momCalc(testConditions.lateralAcceleration(y), ...
                                          testConditions.longitudinalAcceleration(p), ...
                                          vehicleConfig);
        
        [pitchStiffness, pitchAngle, totalRollStiffness(jdx), rollAngle, ...
         rollStiffnessDistribution, NFF, NFR, HR(jdx), WR_ft(jdx), WR_rr(jdx)] = ...
            suspCalc(rollMoment, pitchMoment, vehicleConfig);
        
        [LTE_x, usLatLT_ft, usLatLT_rr, gLatLT_ft, gLatLT_rr, ...
         eLatLT_ft, eLatLT_rr] = loadCalc(vehicleConfig, ...
                                         testConditions.longitudinalAcceleration(p), ...
                                         testConditions.lateralAcceleration(y), ...
                                         rollAngle, rollStiffnessDistribution, ...
                                         totalRollStiffness(jdx));
        
        RSD(jdx) = rollStiffnessDistribution;
        RG(jdx) = rollAngle / testConditions.lateralAcceleration(y);
        PG(jdx) = pitchAngle/testConditions.longitudinalAcceleration(p);
        NF_f(jdx) = NFF;
        NF_r(jdx) = NFR;
        
        % Calculate load transfers
        LTE_y = (gLatLT_rr + eLatLT_rr + usLatLT_rr + gLatLT_ft + eLatLT_ft + usLatLT_ft);
        LLD_ft(jdx) = (usLatLT_rr + gLatLT_ft + eLatLT_ft + usLatLT_ft) / ...
                     (gLatLT_rr + eLatLT_rr + usLatLT_rr + gLatLT_ft + eLatLT_ft + usLatLT_ft);
    end
    
    % Calculate mean values
    rollGrad = mean(RG);
    pitchGrad = mean(PG);
    RSD = mean(RSD);
    LLD_ft = mean(LLD_ft);
    NF_f = mean(NF_f);
    NF_r = mean(NF_r);
    HR = mean(HR);
    WR_rr = mean(WR_rr);
    WR_ft = mean(WR_ft);
    totalRollStiffness = mean(totalRollStiffness);
    pitchStiffness = mean(pitchStiffness);
    
    % Set up dynamics parameters
    dynParams = setupDynamicsParameters(Car, vehicleConfig, totalRollStiffness, pitchStiffness);
    
    % Set up simulation time and inputs
    [simTime, inputAccel] = setupSimulationInputs(testConditions.longitudinalAcceleration(p), ...
                                                testConditions.lateralAcceleration(y));
    
    % Run dynamics simulation
    dynSimResults = Copy_of_simulateVehicleDynamics(dynParams, inputAccel, simTime);
    simResultsCell{idx} = dynSimResults;
    

%  testConditions.velocity(h)
    % Store results
    results(idx, :) = storeResults(RS_ARB_ft(a), RS_ARB_rr(b), RS_Spring_ft(g), ...
                     RS_Spring_rr(t), z, x, frontSusp.motionRatio, rearSusp.motionRatio, ...
                     vehicleConfig.MR_ARB_rr, vehicleConfig.MR_ARB_ft , ...
                     geometry.rollCenterFront(e), geometry.rollCenterRear(f), ...
                     geometry.pitchCenterFront(s), geometry.pitchCenterRear(r), ...
                     geometry.pitchCenterXRear(i), geometry.pitchCenterXFront(o), ...
                     testConditions.lateralAcceleration(y), ...
                     testConditions.longitudinalAcceleration(p), pitchMoment, rollMoment, ...
                     totalRollStiffness, rollGrad, RSD, pitchGrad, rollAngle, ...
                     LTE_x, LTE_y, LLD_ft, idx);
    
    % Display progress
    if simSettings.showProgress && mod(idx, ceil(0.01 * totalSims)) == 0
        fprintf('Progress: %.2f%%\n', 100 * idx / totalSims);
    end
end


% Create results table and save
col_names = {'ARBStiffness_f', 'ARBStiffness_r', 'SpringStiffness_f', 'SpringStiffness_r', 'PositionARBf', 'PositionARBr', ...
             'MR_f', 'MR_r', 'ARBMR_f', 'ARBMR_r', 'RollCenter_hf', 'RollCenter_hr', 'PitchCenter_hf', ...
             'PitchCenter_hr', 'PitchCenter_xr', 'PitchCenter_xf', 'latG', 'lonG', 'PitchMoment', ...
             'RollMoment', 'TotalRollStiffness', 'RollGradient', 'RollStiffnessDistribution', ...
             'PitchGrad', 'RollAngle', 'LTE_x', 'LTE_y', 'LLD_f', ...
               'ConfigurationID'};

resultsTable = array2table(results, 'VariableNames', col_names);
% T_dynSim = cell2table(simResultsCell, 'VariableNames', {'DynamicsSim'});
% resultsTable = [resultsTable, T_dynSim];

%%

% First determine the field names and maximum vector length
if ~isempty(simResultsCell) && ~isempty(simResultsCell{1})
    dynamicFields = fieldnames(simResultsCell{1});
    numSims = numel(simResultsCell);
    
    % Pre-determine maximum length of time series data
    maxLength = 0;
    for idx = 1:numSims
        if ~isempty(simResultsCell{idx})
            maxLength = max(maxLength, length(simResultsCell{idx}.t));
        end
    end
    
    % Preallocate arrays for each dynamic field
    dynData = struct();
    for i = 1:length(dynamicFields)
        fieldName = dynamicFields{i};
        dynData.(fieldName) = NaN(numSims, maxLength);
    end
    
    % Populate the arrays in a single pass
    for idx = 1:numSims
        if ~isempty(simResultsCell{idx})
            simResult = simResultsCell{idx};
            currentLength = length(simResult.t);
            for i = 1:length(dynamicFields)
                fieldName = dynamicFields{i};
                dynData.(fieldName)(idx, 1:currentLength) = simResult.(fieldName)';
            end
        end
    end
    
    % Convert to table columns (faster than adding to existing table)
    dynTable = struct2table(dynData);
    dynTable.Properties.VariableNames = strcat('dyn_', dynTable.Properties.VariableNames);
    
    % Combine with main results table
    resultsTable = [resultsTable, dynTable];
else
    warning('No dynamic simulation results found to process');
end

%% Save 
save(outputFiles.resultsFile, 'resultsTable', 'metadata');
fprintf('Simulation complete. Results saved to %s\n', outputFiles.resultsFile);
visualizeResultsGUI(resultsTable)
%% Helper Functions
function dynParams = setupDynamicsParameters(Car, vehicleConfig, totalRollStiffness, pitchStiffness)
    % Setup dynamics parameters structure
    dynParams.mass = Car.mass;                            % [kg]
    dynParams.track_width = Car.tf;                       % [m]
    dynParams.wheelbase = Car.wb;                         % [m]
    dynParams.h_cg = Car.hCG/1000;                        % [m]
    dynParams.l_f = vehicleConfig.a;                      % [m]
    dynParams.l_r = vehicleConfig.b;                      % [m]
    
    % Moments of Inertia
    dynParams.Ixx = 700;                                  % [kg·m²]
    dynParams.Iyy = 1300;                                 % [kg·m²]
    
    % Suspension Properties
    dynParams.roll_stiffness_spring = totalRollStiffness/2; % [Nm/rad]
    dynParams.roll_stiffness_ARB = totalRollStiffness/2;    % [Nm/rad]
    dynParams.roll_damping = 2000;                        % [Nm/(rad/s)]
    dynParams.pitch_stiffness_spring = pitchStiffness;    % [Nm/rad]
    dynParams.pitch_damping = 2500;                       % [Nm/(rad/s)]
    
    % Roll/Pitch Center Heights
    dynParams.h_rc_front0 = vehicleConfig.RC_ft;          % [m]
    dynParams.h_rc_rear0 = vehicleConfig.RC_rr;           % [m]
    dynParams.h_pc_front0 = vehicleConfig.PC_ft;          % [m]
    dynParams.h_pc_rear0 = vehicleConfig.PC_rr;           % [m]
    
    % Sensitivity factors
    dynParams.k_rf = 0.15;                               % [m/rad]
    dynParams.k_rr = 0.12;                               % [m/rad]
    dynParams.k_pf = 0.1;                                % [m/rad]
    dynParams.k_pr = 0.08;                               % [m/rad]
end

function [simTime, inputAccel] = setupSimulationInputs(lonG, latG)
    % Setup simulation time and input accelerations
    simTime.dt = 0.01;                                   % [s]
    simTime.tFinal = 1;                                  % [s]
    t_vec = 0:simTime.dt:simTime.tFinal;                % [s]
   % Longitudinal acceleration (mild acceleration into corner, deceleration out)
inputAccel.ax = lonG * sin(pi * t_vec / max(t_vec));  % Smooth curve: 0 -> max -> 0

% Lateral acceleration: entering and exiting a corner (waveform)
% Simulate turning right, holding, then exiting
corner_duration = max(t_vec);

inputAccel.ay = latG * sin(2 * pi * t_vec / corner_duration);  
inputAccel.ay(inputAccel.ay < 0) = 0;  % Vehicle turns right only (one-directional)
    inputAccel.az = 9.81 * ones(1, length(t_vec));      % [m/s²]
end

function resultRow = storeResults(varargin)
    % Store all results in a row
    resultRow = [varargin{:}];
end

function [Structs] = ProcessParameterData(raw, StructureNames)
    % Process parameter data from Excel
    n_lines = size(raw,1);
    for i=2:n_lines
        for j=1:length(StructureNames)
            if strcmp(raw{i,1},StructureNames{j})
                eval(strcat('Structs.',StructureNames{j},'.(raw{i,3}) = raw{i,4};'))
            end
        end
    end
end