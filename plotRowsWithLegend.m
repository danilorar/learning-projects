function plotRowsWithLegend(X, Y, legends, xLabel, yLabel,titleG)
    % plotRowsWithLegend plots multiple rows of Y against the same X axis.
    %
    % INPUTS:
    %   X       - A vector representing the X-axis values.
    %   Y       - A matrix where each row corresponds to a series to be plotted.
    %   legends - A cell array of strings for the legend entries (one per row of Y).
    %   xLabel  - A string for the x-axis label.
    %   yLabel  - A string for the y-axis label.
    %
    % OUTPUT:
    %   A plot showing all rows of Y against X with the specified labels and legend.

    % Check that the number of rows in Y matches the length of legends
    if size(Y, 1) ~= length(legends)
        error('The number of rows in Y must match the number of legends.');
    end
    
    % Check that X matches the number of columns in Y
    if length(X) ~= size(Y, 2)
        error('The length of X must match the number of columns in Y.');
    end
    
    % Create the plot
    figure;
    hold on;
    for i = 1:size(Y, 1)
        plot(X, Y(i, :), 'DisplayName', legends{i}); % Plot each row with a legend entry
    end
    hold off;
    
    % Add labels and legend
    xlabel(xLabel);
    ylabel(yLabel);
    title(titleG);
    legend('show', 'Location', 'best'); % Show legend automatically
    grid on; % Optional: Adds a grid for better readability
end
