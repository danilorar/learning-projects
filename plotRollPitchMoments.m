function plotRollPitchMoments(results)
    figure;
    scatter3(results.RC_rr, results.RC_ft, results.rollMoments, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0 .5 .5]);
    xlabel('Roll Center rear');
    ylabel('Rol Center front');
    zlabel('Roll Moment');
    title('Effect of Roll ceneter on Roll Moment ');
    grid on;

    figure;
    scatter3(results.PC_rr, results.PC_ft, results.pitchMoments, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.5 0.5 0]);
    xlabel('Pitch center rear');
    ylabel('Pitch center front');
    zlabel('Pitch Moment');
    title('Effect of Pitch center on Pitch Moment');
    grid on;
end
