classdef VehicleDynamicsModel < handle
    % VehicleDynamicsModel - Class to simulate vehicle roll and pitch dynamics
    % based on suspension parameters and acceleration inputs.
    
    properties
        % Vehicle parameters
        mass            % Vehicle mass (kg)
        Ixx             % Roll moment of inertia (kg*m^2)
        Iyy             % Pitch moment of inertia (kg*m^2)
        wheelbase       % Distance between front and rear axles (m)
        track_width     % Distance between left and right wheels (m)
        cog_height      % Height of center of gravity from ground (m)
        weight_dist_front % Weight distribution to front axle (0-1)
        weight_dist_rear  % Weight distribution to rear axle (0-1)
        
        % Suspension parameters
        front_roll_stiffness    % Front suspension roll stiffness (N*m/rad)
        rear_roll_stiffness     % Rear suspension roll stiffness (N*m/rad)
        front_roll_damping      % Front suspension roll damping (N*m*s/rad)
        rear_roll_damping       % Rear suspension roll damping (N*m*s/rad)
        front_pitch_stiffness   % Front suspension pitch stiffness (N*m/rad)
        rear_pitch_stiffness    % Rear suspension pitch stiffness (N*m/rad)
        front_pitch_damping     % Front suspension pitch damping (N*m*s/rad)
        rear_pitch_damping      % Rear suspension pitch damping (N*m*s/rad)
        
        % Total stiffness and damping
        total_roll_stiffness
        total_roll_damping
        total_pitch_stiffness
        total_pitch_damping
        
        % State variables
        roll_angle      % Current roll angle (rad)
        pitch_angle     % Current pitch angle (rad)
        roll_rate       % Current roll rate (rad/s)
        pitch_rate      % Current pitch rate (rad/s)
        
        % Constants
        g = 9.81        % Gravity (m/s^2)
        
        % Simulation history
        time_history
        roll_history
        pitch_history
        ay_history
        ax_history
    end
    
    methods
        function obj = VehicleDynamicsModel(params)
            % Constructor - Initialize model with parameters
            % params: structure with vehicle and suspension parameters
            
            % Vehicle parameters
            obj.mass = params.mass;
            obj.Ixx = params.Ixx;
            obj.Iyy = params.Iyy;
            obj.wheelbase = params.wheelbase;
            obj.track_width = params.track_width;
            obj.cog_height = params.cog_height;
            
            % Weight distribution
            if isfield(params, 'weight_dist_front')
                obj.weight_dist_front = params.weight_dist_front;
            else
                obj.weight_dist_front = 0.5;
            end
            obj.weight_dist_rear = 1 - obj.weight_dist_front;
            
            % Suspension parameters
            obj.front_roll_stiffness = params.front_roll_stiffness;
            obj.rear_roll_stiffness = params.rear_roll_stiffness;
            obj.front_roll_damping = params.front_roll_damping;
            obj.rear_roll_damping = params.rear_roll_damping;
            obj.front_pitch_stiffness = params.front_pitch_stiffness;
            obj.rear_pitch_stiffness = params.rear_pitch_stiffness;
            obj.front_pitch_damping = params.front_pitch_damping;
            obj.rear_pitch_damping = params.rear_pitch_damping;
            
            % Total stiffness and damping
            obj.total_roll_stiffness = obj.front_roll_stiffness + obj.rear_roll_stiffness;
            obj.total_roll_damping = obj.front_roll_damping + obj.rear_roll_damping;
            obj.total_pitch_stiffness = obj.front_pitch_stiffness + obj.rear_pitch_stiffness;
            obj.total_pitch_damping = obj.front_pitch_damping + obj.rear_pitch_damping;
            
            % Initialize state variables
            obj.roll_angle = 0;
            obj.pitch_angle = 0;
            obj.roll_rate = 0;
            obj.pitch_rate = 0;
            
            % Initialize history arrays
            obj.time_history = [];
            obj.roll_history = [];
            obj.pitch_history = [];
            obj.ay_history = [];
            obj.ax_history = [];
        end
        
        function roll_moment = calculate_roll_moment(obj, lateral_acc)
            % Calculate the rolling moment due to lateral acceleration
            roll_moment = obj.mass * lateral_acc * obj.cog_height;
        end
        
        function pitch_moment = calculate_pitch_moment(obj, longitudinal_acc)
            % Calculate the pitching moment due to longitudinal acceleration
            pitch_moment = obj.mass * longitudinal_acc * obj.cog_height;
        end
        
        function update_dynamics(obj, dt, lateral_acc, longitudinal_acc)
            % Update vehicle dynamics for a single time step
            % dt: time step (s)
            % lateral_acc: lateral acceleration (m/s^2)
            % longitudinal_acc: longitudinal acceleration (m/s^2)
            
            % Calculate moments
            roll_moment = obj.calculate_roll_moment(lateral_acc);
            pitch_moment = obj.calculate_pitch_moment(longitudinal_acc);
            
            % Roll dynamics (lateral acceleration causes roll)
            roll_spring_moment = -obj.total_roll_stiffness * obj.roll_angle;
            roll_damper_moment = -obj.total_roll_damping * obj.roll_rate;
            net_roll_moment = roll_moment + roll_spring_moment + roll_damper_moment;
            roll_angular_acc = net_roll_moment / obj.Ixx;
            
            % Pitch dynamics (longitudinal acceleration causes pitch)
            pitch_spring_moment = -obj.total_pitch_stiffness * obj.pitch_angle;
            pitch_damper_moment = -obj.total_pitch_damping * obj.pitch_rate;
            net_pitch_moment = pitch_moment + pitch_spring_moment + pitch_damper_moment;
            pitch_angular_acc = net_pitch_moment / obj.Iyy;
            
            % Update rates
            obj.roll_rate = obj.roll_rate + roll_angular_acc * dt;
            obj.pitch_rate = obj.pitch_rate + pitch_angular_acc * dt;
            
            % Update angles
            obj.roll_angle = obj.roll_angle + obj.roll_rate * dt;
            obj.pitch_angle = obj.pitch_angle + obj.pitch_rate * dt;
        end
        
        function [time, roll, pitch, ay, ax] = simulate(obj, time_vec, lat_acc_func, long_acc_func)
            % Simulate vehicle dynamics over a time vector with given acceleration inputs
            % time_vec: time vector for simulation
            % lat_acc_func: function handle for lateral acceleration (in g)
            % long_acc_func: function handle for longitudinal acceleration (in g)
            
            % Reset states and history
            obj.roll_angle = 0;
            obj.pitch_angle = 0;
            obj.roll_rate = 0;
            obj.pitch_rate = 0;
            obj.time_history = zeros(size(time_vec));
            obj.roll_history = zeros(size(time_vec));
            obj.pitch_history = zeros(size(time_vec));
            obj.ay_history = zeros(size(time_vec));
            obj.ax_history = zeros(size(time_vec));
            
            % Calculate time step
            if length(time_vec) > 1
                dt = time_vec(2) - time_vec(1);
            else
                dt = 0.01;
            end
            
            % Simulation loop
            for i = 1:length(time_vec)
                t = time_vec(i);
                
                % Get accelerations at current time
                lateral_acc = lat_acc_func(t) * obj.g;  % Convert from g to m/s^2
                longitudinal_acc = long_acc_func(t) * obj.g;  % Convert from g to m/s^2
                
                % Update dynamics
                obj.update_dynamics(dt, lateral_acc, longitudinal_acc);
                
                % Store history
                obj.time_history(i) = t;
                obj.roll_history(i) = obj.roll_angle;
                obj.pitch_history(i) = obj.pitch_angle;
                obj.ay_history(i) = lateral_acc / obj.g;  % Store in g
                obj.ax_history(i) = longitudinal_acc / obj.g;  % Store in g
            end
            
            % Return results if requested
            if nargout > 0
                time = obj.time_history;
                roll = obj.roll_history;
                pitch = obj.pitch_history;
                ay = obj.ay_history;
                ax = obj.ax_history;
            end
        end
        
        function plot_results(obj)
            % Plot simulation results
            
            if isempty(obj.time_history)
                error('No simulation data available. Run simulate() first.');
            end
            
            figure('Position', [100, 100, 800, 900]);
            
            % Roll angle plot
            subplot(3,1,1);
            plot(obj.time_history, obj.roll_history * 180/pi, 'b-', 'LineWidth', 1.5);
            grid on;
            ylabel('Roll Angle (deg)');
            title('Vehicle Roll Response');
            
            % Pitch angle plot
            subplot(3,1,2);
            plot(obj.time_history, obj.pitch_history * 180/pi, 'r-', 'LineWidth', 1.5);
            grid on;
            ylabel('Pitch Angle (deg)');
            title('Vehicle Pitch Response');
            
            % Acceleration inputs
            subplot(3,1,3);
            plot(obj.time_history, obj.ay_history, 'g-', 'LineWidth', 1.5);
            hold on;
            plot(obj.time_history, obj.ax_history, 'm-', 'LineWidth', 1.5);
            grid on;
            xlabel('Time (s)');
            ylabel('Acceleration (g)');
            title('Acceleration Inputs');
            legend('Lateral (g)', 'Longitudinal (g)');
            
            sgtitle('Vehicle Dynamics Simulation Results');
        end
        
        function animate_vehicle(obj, interval_ms, save_animation, filename)
            % Create a 3D animation of the vehicle's roll and pitch motion
            % interval_ms: interval between frames in milliseconds
            % save_animation: boolean to save animation
            % filename: filename to save animation to
            
            if nargin < 2
                interval_ms = 50;
            end
            if nargin < 3
                save_animation = false;
            end
            if nargin < 4
                filename = 'vehicle_dynamics.avi';
            end
            
            if isempty(obj.time_history)
                error('No simulation data available. Run simulate() first.');
            end
            
            % Create figure
            fig = figure('Position', [100, 100, 800, 600]);
            ax = axes('Parent', fig);
            view(ax, 3);
            
            % Vehicle dimensions
            length = obj.wheelbase * 1.3;  % Slightly longer than wheelbase
            width = obj.track_width;
            height = obj.cog_height * 0.8;  % Slightly lower than COG
            
            % Vehicle body points (in vehicle coordinates)
            x = [-length/2, length/2, length/2, -length/2, -length/2, ...
                 -length/2, length/2, length/2, -length/2];
            y = [-width/2, -width/2, width/2, width/2, -width/2, ...
                 -width/2, -width/2, width/2, width/2];
            z = [0, 0, 0, 0, 0, height, height, height, height];
            
            % Initialize plot elements
            lower_rect = line(ax, 'XData', x(1:5), 'YData', y(1:5), 'ZData', z(1:5), ...
                             'Color', 'b', 'LineWidth', 2);
            upper_rect = line(ax, 'XData', [x(6:9), x(6)], 'YData', [y(6:9), y(6)], ...
                             'ZData', [z(6:9), z(6)], 'Color', 'b', 'LineWidth', 2);
            pillar1 = line(ax, 'XData', [x(1), x(6)], 'YData', [y(1), y(6)], ...
                          'ZData', [z(1), z(6)], 'Color', 'b', 'LineWidth', 2);
            pillar2 = line(ax, 'XData', [x(2), x(7)], 'YData', [y(2), y(7)], ...
                          'ZData', [z(2), z(7)], 'Color', 'b', 'LineWidth', 2);
            pillar3 = line(ax, 'XData', [x(3), x(8)], 'YData', [y(3), y(8)], ...
                          'ZData', [z(3), z(8)], 'Color', 'b', 'LineWidth', 2);
            pillar4 = line(ax, 'XData', [x(4), x(9)], 'YData', [y(4), y(9)], ...
                          'ZData', [z(4), z(9)], 'Color', 'b', 'LineWidth', 2);
            
            % Set axis properties
            axis(ax, 'equal');
            xlim(ax, [-length, length]);
            ylim(ax, [-width, width]);
            zlim(ax, [-height/2, height*1.5]);
            xlabel(ax, 'X (m)');
            ylabel(ax, 'Y (m)');
            zlabel(ax, 'Z (m)');
            title(ax, 'Vehicle Roll and Pitch Dynamics');
            grid(ax, 'on');
            
            % Text for displaying angles
            roll_text = text(ax, -length*0.9, -width*0.9, height*1.4, '');
            pitch_text = text(ax, -length*0.9, -width*0.9, height*1.3, '');
            time_text = text(ax, -length*0.9, -width*0.9, height*1.2, '');
            
            % Create video writer if saving
            if save_animation
                v = VideoWriter(filename);
                v.FrameRate = 1000 / interval_ms;
                open(v);
            end
            
            % Play animation
            for i = 1:length(obj.time_history)
                % Get current state
                roll = obj.roll_history(i);
                pitch = obj.pitch_history(i);
                t = obj.time_history(i);
                
                % Rotate vehicle points
                [x_rot, y_rot, z_rot] = obj.rotate_points(x, y, z, roll, pitch);
                
                % Update plot
                set(lower_rect, 'XData', x_rot(1:5), 'YData', y_rot(1:5), 'ZData', z_rot(1:5));
                set(upper_rect, 'XData', [x_rot(6:9), x_rot(6)], 'YData', [y_rot(6:9), y_rot(6)], ...
                    'ZData', [z_rot(6:9), z_rot(6)]);
                set(pillar1, 'XData', [x_rot(1), x_rot(6)], 'YData', [y_rot(1), y_rot(6)], ...
                    'ZData', [z_rot(1), z_rot(6)]);
                set(pillar2, 'XData', [x_rot(2), x_rot(7)], 'YData', [y_rot(2), y_rot(7)], ...
                    'ZData', [z_rot(2), z_rot(7)]);
                set(pillar3, 'XData', [x_rot(3), x_rot(8)], 'YData', [y_rot(3), y_rot(8)], ...
                    'ZData', [z_rot(3), z_rot(8)]);
                set(pillar4, 'XData', [x_rot(4), x_rot(9)], 'YData', [y_rot(4), y_rot(9)], ...
                    'ZData', [z_rot(4), z_rot(9)]);
                
                % Update text
                set(roll_text, 'String', sprintf('Roll: %.2f°', roll * 180/pi));
                set(pitch_text, 'String', sprintf('Pitch: %.2f°', pitch * 180/pi));
                set(time_text, 'String', sprintf('Time: %.2fs', t));
                
                % Capture frame if saving
                if save_animation
                    frame = getframe(fig);
                    writeVideo(v, frame);
                end
                
                drawnow;
                pause(interval_ms/1000);
            end
            
            % Close video writer if saving
            if save_animation
                close(v);
                fprintf('Animation saved to %s\n', filename);
            end
        end
        
        function [x_rot, y_rot, z_rot] = rotate_points(~, x, y, z, roll, pitch)
            % Rotate points based on roll and pitch angles
            % x, y, z: Original coordinates
            % roll, pitch: Roll and pitch angles (rad)
            % Returns rotated coordinates
            
            % Create rotation matrices
            roll_matrix = [1, 0, 0;
                          0, cos(roll), -sin(roll);
                          0, sin(roll), cos(roll)];
            
            pitch_matrix = [cos(pitch), 0, sin(pitch);
                           0, 1, 0;
                           -sin(pitch), 0, cos(pitch)];
            
            % Combine rotations (roll then pitch)
            combined_matrix = pitch_matrix * roll_matrix;
            
            % Apply rotation to each point
            x_rot = zeros(size(x));
            y_rot = zeros(size(y));
            z_rot = zeros(size(z));
            
            for i = 1:length(x)
                point = [x(i); y(i); z(i)];
                rotated = combined_matrix * point;
                x_rot(i) = rotated(1);
                y_rot(i) = rotated(2);
                z_rot(i) = rotated(3);
            end
        end
    end
end