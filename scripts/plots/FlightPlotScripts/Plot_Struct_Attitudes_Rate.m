function [hTurn] = Plot_Struct_Attitudes_Rate(ax, Time, P, Q, R, varargin)
    plotOption = inputParser;
    addOptional(plotOption, 'LineStyle', '-');
    addParameter(plotOption, 'LegendID', '');
    addParameter(plotOption, 'Color', [0 0 1], @(x)isnumeric(x) && any((size(x) == [3,3])))
    addOptional(plotOption, 'MarkerStyle', 'none');
    addParameter(plotOption, 'nMarkers', 100000, @(x)isnumeric(x));
    addParameter(plotOption, 'TimeInterval', [min(Time), max(Time)], @(x)isnumeric(x));

    parse(plotOption, varargin{:});
    
    %% Error handling
    % ...
    %%
    
    %% Color - If users pass only one color, the three data types have the same color
    if(size(plotOption.Results.Color,1) == 1)
        colorP = plotOption.Results.Color;
        colorQ = plotOption.Results.Color;
        colorR = plotOption.Results.Color;
    elseif(size(plotOption.Results.Color,1) == 3)
        colorP = plotOption.Results.Color(1,:);
        colorQ = plotOption.Results.Color(2,:);
        colorR = plotOption.Results.Color(3,:);
    else
        error("Check input color");
    end
    
    %% Plot Interval
    assert(plotOption.Results.TimeInterval(1) < plotOption.Results.TimeInterval(2));
    interval = (Time >= plotOption.Results.TimeInterval(1)) & (Time <= plotOption.Results.TimeInterval(2));
    Indices = unique(round(linspace(1, numel(Time(interval)), plotOption.Results.nMarkers)));
   
    %% P
    if(numel(P) ~= 0)
        assert(all(diff([size(Time), size(P)])));    
        hTurn.LinePhi = plot(ax, Time(interval), P(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s P', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorP);
        hold on;
    end
    
    %% Q
    if(numel(Q) ~= 0)
        assert(all(diff([size(Time), size(Q)])));    
        hTurn.LineTheta = plot(ax, Time(interval), Q(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Q', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorQ);
        hold on;
    end
    
    %% R
    if(numel(R) ~= 0)
        assert(all(diff([size(Time), size(R)])));    
        hTurn.LineHeading = plot(ax, Time(interval), R(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s R', plotOption.Results.LegendID)', ...
            'MarkerIndices', Indices, "Color", colorR);
        hold on;
    end
    
    ylabel(ax, 'Rates [rad/s]');
    xlim(plotOption.Results.TimeInterval);
    xlabel(ax, 'Time [s]');
    legend(ax, 'show');
    grid(ax, 'on'); 
end

