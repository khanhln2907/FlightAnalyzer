function F = calculateNewtonBackwardDividendDifference(x,y)
% calculateNewtonBackwardDividendDifference calculates and returns a divided
% difference table 'F'. Argument 'x' must be equal spacing.
% The table F supplies the basis to fit a [n-1]-degree polynom.

% Number of supporting points
n = length(x);
F = zeros(n);

% First column equals supporting values
for i=1:n
    F(i,1) = y(i);
end

% Divided differences
for i=2:n
    for j=2:i
        F(i,j)=( F(i,j-1) - F(i-1,j-1) ) / ( x(i) - x(i-j+1) );
    end
end



