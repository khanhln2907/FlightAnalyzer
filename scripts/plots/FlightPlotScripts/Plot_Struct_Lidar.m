function [hTurn] = Plot_Struct_Lidar(ax, Time, Value, SignalStrength, varargin)
    plotOption = inputParser;
    addOptional(plotOption, 'LineStyle', '-');
    addParameter(plotOption, 'LegendID', '');
    addParameter(plotOption, 'Color', hsv(1), @(x)isnumeric(x));
    addOptional(plotOption, 'MarkerStyle', 'none');
    addParameter(plotOption, 'nMarkers', 50000, @(x)isnumeric(x));
    addParameter(plotOption, 'TimeInterval', [min(Time), max(Time)], @(x)isnumeric(x));

    parse(plotOption, varargin{:});
    
    %% Error handling
    % ...
    %%
    
    %% Plot Interval
    assert(plotOption.Results.TimeInterval(1) < plotOption.Results.TimeInterval(2));
    interval = (Time >= plotOption.Results.TimeInterval(1)) & (Time <= plotOption.Results.TimeInterval(2));
    Indices = unique(round(linspace(1, numel(Time(interval)), plotOption.Results.nMarkers)));
   
    %% Value
    if(numel(Value) ~= 0)
        yyaxis left;
        assert(all(diff([size(Time), size(Value)])));    
        hTurn.LineValue = plot(ax, Time(interval), Value(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Lidar', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", plotOption.Results.Color(1,:));
        hTurn.LineValue.Color(4) = 0.7;
        hold on;
        ylabel(ax, 'Distance [m]');
    end
    
    %% Signal Strength
    if(numel(SignalStrength) ~= 0)
        yyaxis right;
        assert(all(diff([size(Time), size(SignalStrength)])));    
        hTurn.LineSS = plot(ax, Time(interval), SignalStrength(interval), 'LineStyle', '--', ...
            'DisplayName', sprintf('%s Signal Strength [%%]', plotOption.Results.LegendID), "Color", plotOption.Results.Color(1,:));
        hold on;
        hTurn.LineSS.Color(4) = 0.3; % Same color but more transparent
        ylabel(ax, 'Signal Strength [%]');
    end
    
    yyaxis left;
    xlim(plotOption.Results.TimeInterval);
    xlabel(ax, 'Time [s]');
    tmp = legend(ax, 'show');
    tmp.FontSize = 30;
    grid(ax, 'on'); 
end

