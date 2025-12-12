function plotRollPitchRates(results)
    figure;
    scatter3(results.RS_Spring_ft, results.RS_Spring_rr, results.rollRateSpringsARB_ft, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0 .75 .75]);
    xlabel('Front Spring Stiffness');
    ylabel('Rear Spring Stiffness');
    zlabel('Roll Rate');
    title('Effect of Spring Stiffness on Roll Rate');
    grid on;

    figure;
    scatter3(results.RS_Spring_ft, results.RS_Spring_rr, results.pitchRate, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.75 .25 .5]);
    xlabel('Front Spring Stiffness');
    ylabel('Rear Spring Stiffness');
    zlabel('Pitch Rate');
    title('Effect of Spring Stiffness on Pitch Rate');
    grid on;
end
