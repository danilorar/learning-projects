function SurfacePlot(resultsTable,xField,yField,zField,Title)
%SURFACEPLOT Summary of this function goes here
%   Detailed explanation goes here



X = unique(resultsTable.(xField));
Y = unique(resultsTable.(yField));

%create a 2D grid for X and Y
[X_grid, Y_grid] = meshgrid(X, Y);

%interpolate Z values for the grid
Z_values = resultsTable.(zField);
Z_grid = griddata(resultsTable.(xField), resultsTable.(yField), Z_values, X_grid, Y_grid, 'linear');

%lot the surface
surf(X_grid, Y_grid, Z_grid,"EdgeColor","none","FaceColor","interp");

%   Label the axes
xlabel(xField,"Interpreter","none");
ylabel(yField,"Interpreter","none");
zlabel(zField,"Interpreter","none");
title(Title);
colorbar;
grid on;