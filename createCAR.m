function updatedStruct = creatCAR(inputStruct, tableData)
    % Function to add all fields from a table to a struct
    %
    % Parameters:
    % inputStruct - The original struct to be updated
    % tableData   - A MATLAB table containing the fields to be added
    %
    % Returns:
    % updatedStruct - The updated struct with all fields from the table
    
    % Validate inputStruct
    if ~isstruct(inputStruct)
        error('inputStruct must be a struct.');
    end

    % Validate tableData
    if ~istable(tableData)
        error('tableData must be a MATLAB table.');
    end

    % Get all field names from the table
    fieldNames = tableData.Properties.VariableNames;

    % Start with the original struct
    updatedStruct = inputStruct;

    % Add each table field to the struct
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
        updatedStruct.(fieldName) = tableData.(fieldName);
    end
end
