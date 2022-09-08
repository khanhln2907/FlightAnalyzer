function Colors = CalcColorGradient(MinColor, MaxColor, nValues)
%function Color = CalcColorGradient(MinColor, MaxColor, Values)
% Creates colors based on a vector interpolating two colors between the min
% and max values of the vector.

%X = [min(Values) max(Values)];

MinColor = EnsureColumnVector(MinColor);
MaxColor = EnsureColumnVector(MaxColor);

Y = [MinColor' MaxColor'];


for iCol = 1:length(MinColor)
	
	Colors(:, iCol) = linspace(MinColor(iCol), MaxColor(iCol), nValues);
	
		%Colors(:, iCol) = interp1(X, Y(iCol,:), Values);
end
end


function Vector = EnsureColumnVector(Vector)

if size(Vector, 1) > size(Vector, 2)
	Vector = Vector';
end

end