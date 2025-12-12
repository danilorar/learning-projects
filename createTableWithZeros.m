function resultTable = createTableWithZeros(numRows, varargin)
    % createTableWithZeros - Creates a table with a specified number of rows
    % filled with zeros, using the given variable names as column names.
    %
    % Syntax: resultTable = createTableWithZeros(numRows, var1, var2, ...)
    %
    % Inputs:
    %   numRows - Number of rows for the table (non-negative integer)
    %   varargin - Variable number of column names (strings or chars)
    %
    % Outputs:
    %   resultTable - A table with the specified column names and rows of zeros
    
    % Validate inputs
    if ~isnumeric(numRows) || ~isscalar(numRows) || numRows < 0 || floor(numRows) ~= numRows
        error('numRows must be a non-negative integer.');
    end
    
    if isempty(varargin)
        error('At least one column name must be provided.');
    end
    
    % Initialize the table with zeros
    numCols = length(varargin);
    data = zeros(numRows, numCols);
    
    % Create the table
    resultTable = array2table(data, 'VariableNames', varargin);
end
