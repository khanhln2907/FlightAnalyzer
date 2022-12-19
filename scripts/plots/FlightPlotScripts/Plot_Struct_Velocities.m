function [hTurn] = Plot_Struct_Velocities(ax, Time, VelNorth, VelEast, VelDown, varargin)
    plotOption = inputParser;
    addOptional(plotOption, 'LineStyle', '-');
    addParameter(plotOption, 'LegendID', '');
    addParameter(plotOption, 'Color', [0 0 1], @(x)isnumeric(x) && any((size(x) == [3,3])))
    addOptional(plotOption, 'MarkerStyle', 'none');
    addParameter(plotOption, 'nMarkers', 2000, @(x)isnumeric(x));
    addParameter(plotOption, 'TimeInterval', [min(Time), max(Time)], @(x)isnumeric(x));

    parse(plotOption, varargin{:});
    
    %% Error handling
    % ...
    %%
    
    %% Plot Interval
    assert(plotOption.Results.TimeInterval(1) < plotOption.Results.TimeInterval(2));
    interval = (Time >= plotOption.Results.TimeInterval(1)) & (Time <= plotOption.Results.TimeInterval(2));
    Indices = unique(round(linspace(1, numel(Time(interval)), plotOption.Results.nMarkers)));    
    
    %% Color - If users pass only one color, the three data types have the same color
    if(size(plotOption.Results.Color,1) == 1)
        colorVn = plotOption.Results.Color;
        colorVe = plotOption.Results.Color;
        colorVd = plotOption.Results.Color;
    elseif(size(plotOption.Results.Color,1) == 3)
        colorVn = plotOption.Results.Color(1,:);
        colorVe = plotOption.Results.Color(2,:);
        colorVd = plotOption.Results.Color(3,:);
    else
        error("Check input color");
    end
    
    
    %% Vn
    if(numel(VelNorth) ~= 0)
        assert(all(diff([size(Time), size(VelNorth)])));    
        hTurn.LineNorth = plot(ax, Time(interval), VelNorth(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Vel North', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorVn);
        hold on;
    end
    
    %% Ve
    if(numel(VelEast) ~= 0)
        assert(all(diff([size(Time), size(VelEast)])));    
        hTurn.LineEast = plot(ax, Time(interval), VelEast(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Vel East', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorVe);
        hold on;
    end
    
    %% Vd
    if(numel(VelDown) ~= 0)
        assert(all(diff([size(Time), size(VelDown)])));    
        hTurn.LineDown = plot(ax, Time(interval), VelDown(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Vel Down', plotOption.Results.LegendID)', ...
            'MarkerIndices', Indices, "Color", colorVd);
        hold on;
    end
    
    ylabel(ax, 'Velocity [m/s]');
    xlim(plotOption.Results.TimeInterval);
    xlabel(ax, 'Time [s]');
    legend(ax, 'show');
    grid(ax, 'on');
end

