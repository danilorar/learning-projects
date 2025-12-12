function drawGGDiagram(vehicleSpeed, mu, m, g)
    % Inputs:
    % vehicleSpeed: Speed of the vehicle (m/s)
    % mu: Friction coefficient
    % m: Vehicle mass (kg)
    % g: Gravitational acceleration (m/s^2)

    % Constants
    Fz = m * g; % Normal force (assumed flat surface)

    % Friction limits
    ax_max = mu * Fz / m; % Maximum longitudinal acceleration
    ay_max = mu * Fz / m; % Maximum lateral acceleration

    % Generate GG Diagram points
    theta = linspace(0, 2*pi, 100); % Angle range for ellipse
    ax = ax_max * cos(theta);
    ay = ay_max * sin(theta);

    % Simulate vehicle performance limits
    [AX, AY] = meshgrid(linspace(-ax_max, ax_max, 50), linspace(-ay_max, ay_max, 50));
    feasibleRegion = (AX/ax_max).^2 + (AY/ay_max).^2 <= 1;

    % Plot GG Diagram
    figure;
    hold on;
    grid on;
    colormap('jet');
    contourf(AX, AY, feasibleRegion, [0 1], 'LineColor', 'none');
    colorbar;

    % Plot Friction Ellipse
    plot(ax, ay, 'r', 'LineWidth', 2);

    % Vehicle speed-dependent acceleration markers
    velocityLine_x = linspace(-ax_max, ax_max, 100);
    velocityLine_y = sqrt((mu * vehicleSpeed^2).^2 - velocityLine_x.^2);
    plot(velocityLine_x, velocityLine_y, 'k--', 'LineWidth', 1.5);
    plot(velocityLine_x, -velocityLine_y, 'k--', 'LineWidth', 1.5);

    % Labels and Legends
    xlabel('Longitudinal Acceleration (m/s^2)');
    ylabel('Lateral Acceleration (m/s^2)');
    title('GG Diagram with Friction Ellipse');
    legend('Feasible Region', 'Friction Ellipse', 'Speed Dependency');
    axis equal;
end
