function visualizeResultsGUI(resultsTable)
    %% Variable Setup
    varNames = resultsTable.Properties.VariableNames;
    dynVars = varNames(contains(varNames, 'dyn_'));
    staticVars = setdiff(varNames, dynVars);
    allConfigs = resultsTable.ConfigurationID;

    %% UI Setup
    fig = uifigure('Name', 'Vehicle Dynamics Result Visualizer', 'Position', [100 100 1300 700]);

    % --- FILTER SECTION ---
    uilabel(fig, 'Position', [20 660 120 22], 'Text', 'Filter Variable:');
    filterDrop = uidropdown(fig, 'Items', staticVars, 'Position', [130 660 150 22], ...
        'ValueChangedFcn', @(dd, event) updateValueDropdowns());

    minDrop = uidropdown(fig, 'Position', [300 660 100 22]);
    maxDrop = uidropdown(fig, 'Position', [420 660 100 22]);

    applyFilterBtn = uibutton(fig, 'Text', 'Apply Filter', 'Position', [540 660 100 22], ...
        'ButtonPushedFcn', @(btn, event) applyFilter());

    resetFilterBtn = uibutton(fig, 'Text', 'Reset Filters', 'Position', [650 660 100 22], ...
        'ButtonPushedFcn', @(btn, event) resetFilters());

    uilabel(fig, 'Position', [20 620 200 22], 'Text', 'Applied Filters:');
    filterList = uilistbox(fig, 'Position', [20 500 300 120]);

    % --- CONFIGURATION SELECTION ---
    uilabel(fig, 'Position', [20 470 300 22], 'Text', 'Select Configuration IDs to Compare:');
    configList = uilistbox(fig, 'Multiselect', 'on', 'Position', [20 320 300 150]);

    % --- TIME RESPONSE SECTION ---
    uilabel(fig, 'Position', [20 290 300 22], 'Text', 'Select Dynamic Variables to Plot:');
    dynList = uilistbox(fig, 'Items', dynVars, 'Multiselect', 'on', 'Position', [20 140 300 150]);

    plotTimeBtn = uibutton(fig, 'Text', 'Plot Time Responses', ...
        'Position', [20 100 300 30], 'ButtonPushedFcn', @(btn, event) plotTimeResponses());

    ax1 = uiaxes(fig, 'Position', [340 360 940 300]);
    title(ax1, 'Time Responses'); xlabel(ax1, 'Time [s]'); ylabel(ax1, 'Response');

    % --- 3D PLOT SECTION ---
    uilabel(fig, 'Position', [340 320 200 22], 'Text', 'Select X, Y, Z Axes:');
    xDrop = uidropdown(fig, 'Items', staticVars, 'Position', [340 290 120 22]);
    yDrop = uidropdown(fig, 'Items', staticVars, 'Position', [470 290 120 22]);
    zDrop = uidropdown(fig, 'Items', staticVars, 'Position', [600 290 120 22]);

    plotTypeDrop = uidropdown(fig, 'Items', {'Scatter', 'Surface'}, ...
        'Position', [740 290 100 22], 'Value', 'Scatter');

    btn3D = uibutton(fig, 'Text', 'Plot 3D', 'Position', [850 290 100 22], ...
        'ButtonPushedFcn', @(btn, event) plot3D());

    ax2 = uiaxes(fig, 'Position', [340 20 940 260]);
    title(ax2, '3D Visualization');

    %% Internal Filter Tracker
    appliedFilters = containers.Map();

    %% --- CALLBACK FUNCTIONS ---

    function updateValueDropdowns()
        var = filterDrop.Value;
        vals = unique(resultsTable.(var));
        valsStr = cellstr(string(vals));
        minDrop.Items = valsStr;
        maxDrop.Items = valsStr;
        minDrop.Value = valsStr{1};
        maxDrop.Value = valsStr{end};
    end

    function applyFilter()
        var = filterDrop.Value;
        minVal = str2double(minDrop.Value);
        maxVal = str2double(maxDrop.Value);
        appliedFilters(var) = [minVal, maxVal];

        updateFilterDisplay();
        updateConfigList();
    end

    function resetFilters()
        appliedFilters = containers.Map();
        updateFilterDisplay();
        configList.Items = string(allConfigs);
    end

    function updateFilterDisplay()
        keys = appliedFilters.keys;
        items = strings(1, length(keys));
        for i = 1:length(keys)
            range = appliedFilters(keys{i});
            items(i) = sprintf('%s: [%g to %g]', keys{i}, range(1), range(2));
        end
        filterList.Items = items;
    end

    function updateConfigList()
        mask = true(height(resultsTable), 1);
        keys = appliedFilters.keys;
        for i = 1:length(keys)
            range = appliedFilters(keys{i});
            mask = mask & (resultsTable.(keys{i}) >= range(1)) & (resultsTable.(keys{i}) <= range(2));
        end
        configList.Items = string(resultsTable.ConfigurationID(mask));
    end

    function plotTimeResponses()
        selectedIDs = str2double(configList.Value);
        selectedVars = dynList.Value;
        cla(ax1); hold(ax1, 'on');
        colors = lines(length(selectedIDs));
        for i = 1:length(selectedIDs)
            rowIdx = find(resultsTable.ConfigurationID == selectedIDs(i), 1);
            if isempty(rowIdx), continue; end
            t = resultsTable.dyn_t(rowIdx, :); t = t(~isnan(t));
            for j = 1:length(selectedVars)
                y = resultsTable.(selectedVars{j})(rowIdx, :); y = y(~isnan(y));
                plot(ax1, t, y, 'DisplayName', sprintf('Conf %d - %s', selectedIDs(i), selectedVars{j}), ...
                    'Color', colors(i,:));
            end
        end
        legend(ax1, 'show');
        hold(ax1, 'off');
    end

    function plot3D()
        xVar = xDrop.Value;
        yVar = yDrop.Value;
        zVar = zDrop.Value;
        mode = plotTypeDrop.Value;

        % Apply current filter
        mask = true(height(resultsTable), 1);
        keys = appliedFilters.keys;
        for i = 1:length(keys)
            range = appliedFilters(keys{i});
            mask = mask & (resultsTable.(keys{i}) >= range(1)) & (resultsTable.(keys{i}) <= range(2));
        end

        x = resultsTable.(xVar)(mask);
        y = resultsTable.(yVar)(mask);
        z = resultsTable.(zVar)(mask);

        cla(ax2);
        if strcmp(mode, 'Scatter')
            scatter3(ax2, x, y, z, 40, z, 'filled');
        else
            try
                % Interpolate for gridding
                [Xq, Yq] = meshgrid(linspace(min(x), max(x), 40), linspace(min(y), max(y), 40));
                Zq = griddata(x, y, z, Xq, Yq, 'natural');
                surf(ax2, Xq, Yq, Zq);
                shading interp;
            catch
                uialert(fig, 'Surface plotting failed. Not enough data or bad interpolation.', 'Error');
            end
        end

        xlabel(ax2, xVar); ylabel(ax2, yVar); zlabel(ax2, zVar);
        title(ax2, sprintf('%s Plot: %s vs %s vs %s', mode, xVar, yVar, zVar));
        grid(ax2, 'on');
        view(ax2, 3);
    end

    %% Initialize dropdowns
    updateValueDropdowns();
end
