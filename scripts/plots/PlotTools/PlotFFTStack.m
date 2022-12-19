function [FigHandle, cb] = PlotFFTStack(f, A, X, FigHandle)
%% function [FigHandle, cb] = PlotFFTStack(f, A, Xvalues, FigHandle)
% This function plots several spectra over a third quantity
% f:     Vector of frequencies
% A:     Amplitude matrix where size(A,1) = length(f);
%        A(:, n) represents the n-th slice
% X:     Vector, where each value corresponds to a slice.

if nargin < 4
	FigHandle = figure();
end

hold on;

% p_0 = 20e-6; % Pa

nSlices = size(A, 2);
nBins = length(f);

% Distance between stack centers
deltaX = X(2:end) - X(1:end-1);

X_Shifted(2*length(X)) = 0;

Z(size(A,1), 1:2*length(X)) = 0;

for n = 1:nSlices
	
	% Create contour stripe of halve the distance between the current
	% and the next stripe
	% ----- 1 ----- 1.5 ---------- 2.5 ----- 3
	%   |       |            |            |       |
	%   0.75   1.25         2.0           2.75   3.25
	% This means that n X-values turn into 2n values, since we split each
	% value into symmetrical border values
	
	
	% For the first stripe the width to the left should equal that to
	% the right, which is the halve-distance between the current and
	% the next stripe
	if n == 1
		Xlow = X(n)-deltaX(n)/2;
		Xhigh = X(n)+deltaX(n)/2;
	elseif n == length(X)
		% For the last stripe the right boundary should be symmetric to
		% the left
		Xlow = X(n) - (X(n) - X(n-1)) /2;
		Xhigh = X(n) + (X(n) - X(n-1)) /2 ;
	else
		% For intermediate stripes, the upper and lower boundary should
		% lie at the center between the neighbouring levels
		Xlow = X(n)- (X(n) - X(n-1)) / 2;
		Xhigh = X(n) + (X(n+1) - X(n)) /2;
	end
	
	X_Shifted(2*n-1) = Xlow;
	X_Shifted(2*n) = Xhigh;
	
	Z(:, 2*n-1) = A(:,n);
	Z(:, 2*n) = A(:, n);
	%                 X_contour = [Xlow, Xhigh];
	%
	%                 Y = f;
	%
	%                 [~, c] = contourf(X_contour,Y,Z, nLevels, 'Fill', 'on', 'LineColor', 'none', 'LineStyle', 'none', 'Clipping', 'off');
	%                 clear Z;
 end
	%
	%     else
	%
	%         % When interpolation is desired, just construct a normal Z matrix for each f,x point
	%         for iSlice = 1:nSlices
	%             Z(:,iSlice) = A(:,iSlice);
	%         end
	%
	%         Y = f;
	%
	%         [~, c] = contourf(X,Y,Z, nLevels, 'Fill', 'on', 'LineColor', 'none', 'LineStyle', 'none', 'Clipping', 'off');
	%         clear Z;
	%     end
	%
	
	% Since we introduced additional X-values at the boundaries, we need to
	% duplicate the A-values there

	
	surf(X_Shifted, f, Z, 'EdgeColor', 'none');
	view(0,90);
	
	xlim([min(X_Shifted) max(X_Shifted)]);
	
	hold off;
	%
	%     A = [fftDataVector{1:end}];
	%     A = vertcat([A.A]);
	%     A = reshape(A, 1024, length(fftDataVector));
	%     contour(Xvalues, Y, A, nLevels, 'Fill', 'on')
	
	cb = colorbar;
	colormap hot;
	
	grid on;
	
end

