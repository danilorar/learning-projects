function Config = storeInStructure(varargin)
    % Create an empty structure
    Config = struct();
    
    % Loop through each input argument
    for i = 1:length(varargin)
        % Get the name of the variable being passed as input
        fieldName = inputname(i);
        
        % Get the value of the variable
        fieldValue = varargin{i};
        
        % Check if the field name is valid (non-empty string)
        if ~isempty(fieldName)
            % Store the value in the structure with the variable's name as the field name
            Config.(fieldName) = fieldValue;
        else
            error('Input variable name cannot be empty.');
        end
    end
end