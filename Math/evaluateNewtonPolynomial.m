function y = evaluateNewtonPolynomial(F,x,x0)
% evaluateNewtonPolynomial inter- or extrapolates a Newton polynomial from
% the divided difference table 'F' at 'x0'.
% Argument 'x' must be equal spacing.

n = size(F,1);

% Newton Gregory Backward Interpolation
y = F(n,n);
for i=n-1:-1:1
    y = y * (x0-x(i)) + F(i,i);
end
