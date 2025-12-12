function interpolatedArray = matchArrayLength(array1, array2)
    % matchArrayLength interpolates each row of array1 to match the length of array2.
    %
    % INPUTS:
    %   array1 - The array to be interpolated (can have multiple rows).
    %   array2 - The reference array whose length will be matched.
    %
    % OUTPUT:
    %   interpolatedArray - The interpolated array with the same number of rows as array1
    %                       and the same number of columns as array2.
    
    % Get the size of array1
    [numRows, numCols] = size(array1);
    
    % Preallocate the output array
    numColsTarget = length(array2);
    interpolatedArray = zeros(numRows, numColsTarget);
    
    % Generate the new indices for interpolation
    newIndices = linspace(1, numCols, numColsTarget);
    
    % Interpolate each row
    for row = 1:numRows
        interpolatedArray(row, :) = interp1(1:numCols, array1(row, :), newIndices);
    end
end
