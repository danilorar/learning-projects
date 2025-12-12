function plotRollPitchSurface(results)

    [X, Y] = meshgrid(unique(results.RS_Spring_ft), unique(results.MR_ft));
    Z = griddata(unique(results.RS_Spring_ft), unique(results.MR_ft), unique(results.rollRateSpringsARB_ft), X, Y);
    surf(X, Y, Z);
    colorbar;
    xlabel('K_{Sft}');
    ylabel('MR_{ft}');
    zlabel('Roll rate');
end
