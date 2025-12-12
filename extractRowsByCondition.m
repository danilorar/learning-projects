function extractedTable = extractRowsByCondition(inputTable, conditions)
    % extractRowsByCondition - Extract rows that meet specific conditions.
    %
    % Syntax:
    % extractedTable = extractRowsByCondition(inputTable, conditions)
    %
    % Inputs:
    %   inputTable - MATLAB table containing the data.
    %   conditions - Structure where field names correspond to table column names,
    %                and field values can either be:
    %                  - A scalar value for exact match.
    %                  - A 2-element vector [min, max] for range match.
    %
    % Output:
    %   extractedTable - Subset of the inputTable that satisfies the conditions.
    %
    % Example:
    %   conditions = struct('Velocity', [40, 60], 'LatG', 0.3);
    %   extractedTable = extractRowsByCondition(resultsTable, conditions);

    % Validate inputs
    if ~istable(inputTable)
        error('Input must be a table.');
    end
    if ~isstruct(conditions)
        error('Conditions must be provided as a structure.');
    end

    % Initialize a logical array for row selection
    rowSelection = true(height(inputTable), 1);

    % Loop through each condition
    conditionFields = fieldnames(conditions);
    for i = 1:length(conditionFields)
        columnName = conditionFields{i};
        conditionValue = conditions.(columnName);

        % Check if column exists in the table
        if ~ismember(columnName, inputTable.Properties.VariableNames)
            error('Column "%s" does not exist in the table.', columnName);
        end

        % Apply condition based on its type
        if isscalar(conditionValue)
            % Exact match
            rowSelection = rowSelection & (inputTable.(columnName) == conditionValue);
        elseif isvector(conditionValue) && numel(conditionValue) == 2
            % Range match
            rowSelection = rowSelection & ...
                (inputTable.(columnName) >= conditionValue(1) & ...
                 inputTable.(columnName) <= conditionValue(2));
        else
            error('Condition for column "%s" must be a scalar or a 2-element vector.', columnName);
        end
    end

    % Extract rows that satisfy all conditions
    extractedTable = inputTable(rowSelection, :);
end
