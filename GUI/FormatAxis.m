function [ax] = FormatAxis(Ax, Width, AspectRatio, varargin)
        
         if ~exist('Ax', 'var')
            Ax = axis;
        end

        p=inputParser;
        addOptional(p, 'Width', 8);
        addOptional(p, 'AspectRatio', 8/6);
        addParameter(p, 'MarkerSize', 12, @(x)isnumeric(x));
        parse(p, Width, AspectRatio, varargin{:});
        
        curAx = Ax;
        AspectRatio = p.Results.AspectRatio;
        Width = p.Results.Width;
        
        ChartFontSize = 30;    % Point
        ChartLineWidth = 2;
        ChartMarkerSize = p.Results.MarkerSize;
    
        % Editting the plot format
        curAx.FontUnits = 'points';
        curAx.FontSize = ChartFontSize;
       
        set(curAx,'xminorgrid','on','yminorgrid','on')
        
        leg = findobj(curAx, 'Type', 'Legend');
        if ~isempty(leg)
            leg.FontSize = ChartFontSize;
        end
        
        markers = findobj(curAx, 'Type', 'marker');
        set(markers, 'MarkerSize', ChartMarkerSize);
        
        lines = findobj(curAx, 'Type', 'line');
        set(lines, 'LineWidth', ChartLineWidth);
        set(lines, 'MarkerSize', ChartMarkerSize);
		
		% Format errorbars...
		errBars = findobj(curAx, 'Type', 'errorbar');
		set(errBars, 'LineWidth', ChartLineWidth);
		set(errBars, 'CapSize', 5*ChartLineWidth);
        
        stems = findall(curAx, 'Type', 'stem');
        set(stems, 'LineWidth', ChartLineWidth);
        
        % Check if there is a ColorBar
        cBar = findobj(curAx, 'Type', 'ColorBar');
        if length(cBar) == 1     
            cBar.FontSize = ChartFontSize;
            cL = cBar.Label;
        end
        
        
        % Check if there is a ColorBar
        cBar = findobj(curAx, 'Type', 'ColorBar');
        
        % Get the size of the figure, without border and colorbar
        TI = curAx.TightInset;
        LI = curAx.LooseInset;
        
        if length(cBar) == 1
            % Make space for the colorbar label on the right
            TI(3) = TI(3) + 0.1*8/ Width;
            TI(4) = TI(4) + 0.05*6 / (Width / AspectRatio);
        end
        
        % Workaround for matlab bug: If a subplot contains a colorbar, matlab seems to ignore the Loose Inset property
        % on normal graphs
%         cH = findobj(curAx, 'Type', 'Contour');
%         if ~length(figCbar) > 0 || length(cH) > 0
%             curAx.LooseInset = TI;
%         else
%             disp('Ignoring LooseInset since a subplot-colorbar was detected');
%         end
    
end

