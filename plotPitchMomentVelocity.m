unction plotPitchMomentVelocity(results, config)
    figure;
    scatter(config.velocity, results.pitchMoments, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.3 0.4 0.8]);
    xlabel('Vehicle Velocity (m/s)');
    ylabel('Pitch Moment');
    title('Effect of Velocity on Pitch Moment');
    grid on;
end
