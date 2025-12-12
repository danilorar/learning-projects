function plotRollMomentAcceleration(results, config)
    figure;
    scatter3(config.latG, config.lonG, results.rollMoments, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.5 0.1 0.7]);
    xlabel('Lateral Acceleration (G)');
    ylabel('Longitudinal Acceleration (G)');
    zlabel('Roll Moment');
    title('Effect of Acceleration on Roll Moment');
    grid on;
end
