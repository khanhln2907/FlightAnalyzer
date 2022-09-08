function [fig, c, cb] = PlotContourStack(XYdata, nX)
    % function fig = ContourStackPlot(X{n,k}, Y{n,k})
    % XYdata:      Array of XYData objects containing the stacks to plot
    % nX:          Number of FFT bins requested in the plot
    
    fig = figure();
    hold on;
    
    p_0 = 20e-6; % Pa
    
    if nargin < 2
        nPoints = 10000;
    else
        nPoints = nX;
    end
    
    for n = 1:length(XYdata)
        Stack = XYdata(n);
        
        % Dirty hack, since ReduceFftBins expects phase input
        P = zeros(1,length(Stack.X));
        
        % Resample in order to reduce excessively small peaks
        if length(Stack.X) > nPoints
            [X, A, ~] = ReduceFftBins(Stack.X, Stack.Y, P, nPoints);
        else
            X = Stack.X;
            A = Stack.Y;
        end
        
        % Convert to SPL
        A = SoundPressure2SPL(A);
        
        Y = [n-0.4, n+0.4];
        
        Z(1,:) = A;
        Z(2,:) = Z(1,:);
        
        [~, c] = contour(X,Y,Z, 'LevelStep', 1, 'Fill', 'on');
        clear Z;
    end
    
    cb = colorbar;
    % caxis([0 0.5*max([XYdata.Y])]);
    
    
    colormap hot;
    
    yticks(1:length(XYdata));
    
end

