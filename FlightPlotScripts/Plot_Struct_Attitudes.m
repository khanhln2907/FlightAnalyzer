function [hTurn] = Plot_Struct_Attitudes(ax, Time, Phi, Theta, Psi, varargin)
    plotOption = inputParser;
    addOptional(plotOption, 'LineStyle', '-');
    addParameter(plotOption, 'LegendID', '');
    addParameter(plotOption, 'Color', [0 0 1], @(x)isnumeric(x) && any((size(x) == [3,3]) | (size(x) == [1,3])))
    addOptional(plotOption, 'MarkerStyle', 'o');
    addParameter(plotOption, 'nMarkers', 2000000, @(x)isnumeric(x));
    addParameter(plotOption, 'TimeInterval', [min(Time), max(Time)], @(x)isnumeric(x));

    parse(plotOption, varargin{:});
    
    %% Error handling
    % ...
    %%
    
    %% Color - If users pass only one color, the three data types have the same color
    if(size(plotOption.Results.Color,1) == 1)
        colorPhi = plotOption.Results.Color;
        colorTheta = plotOption.Results.Color;
        colorPsi = plotOption.Results.Color;
    elseif(size(plotOption.Results.Color,1) == 3)
        colorPhi = plotOption.Results.Color(1,:);
        colorTheta = plotOption.Results.Color(2,:);
        colorPsi = plotOption.Results.Color(3,:);
    end
    
    %% Plot Interval
    assert(plotOption.Results.TimeInterval(1) < plotOption.Results.TimeInterval(2));
    interval = (Time >= plotOption.Results.TimeInterval(1)) & (Time <= plotOption.Results.TimeInterval(2));
    Indices = unique(round(linspace(1, numel(Time(interval)), plotOption.Results.nMarkers)));
   
    %% Phi
    if(numel(Phi) ~= 0)
        yyaxis left;
        assert(all(diff([size(Time), size(Phi)])));    
        hTurn.LinePhi = plot(ax, Time(interval), Phi(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Phi [Â°]', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorPhi);
        hold on;
        ylabel(ax, 'Attitude [Â°]');
    end
    
    %% Theta
    if(numel(Theta) ~= 0)
        yyaxis left;
        assert(all(diff([size(Time), size(Theta)])));    
        hTurn.LineTheta = plot(ax, Time(interval), Theta(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Theta [°]', plotOption.Results.LegendID), ...
            'MarkerIndices', Indices, "Color", colorTheta);
        hold on;
        ylabel(ax, 'Attitude [°]');
    end
    
    %% Psi
    if(numel(Psi) ~= 0)
        yyaxis right;
        assert(all(diff([size(Time), size(Psi)])));    
        hTurn.LineHeading = plot(ax, Time(interval), Psi(interval), ...
            'LineStyle', plotOption.Results.LineStyle, ...
            'Marker', plotOption.Results.MarkerStyle, ...
            'DisplayName', sprintf('%s Psi [°]', plotOption.Results.LegendID)', ...
            'MarkerIndices', Indices, "Color", colorPsi);
        hold on;
        ylabel(ax, 'Heading [°]');
    end
    
    xlim(plotOption.Results.TimeInterval);
    xlabel(ax, 'Time [s]');
    legend(ax, 'show');
    grid(ax, 'on'); 
end

