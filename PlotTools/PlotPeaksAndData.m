function [out] = PlotPeaksAndData(X, Y, minPeakDist, prominence, varargin )
    %function [out] = PlotPeaksAndData(X, Y, <minPeakDist=0>, <prominence=0>, varargin)
    % Optional parameters:
    % 'ax':             Axes object in which this data should be plotted. If not specified creates a new figure
    % 'PeakMode':       'max' plots only maxima (peaks) (default)
    %                   'min' plots minima (valleys)
    %                   'both' shows both
    % 'MarkerStyle':    Style of markers for peaks. Default: '.'
    % 'LabelPeakMode':  'none' (default) does not label the peaks.
    %                   'x' inserts labels above the peak markers indicating the x value of the peak (default)
    %                   'y' indicate y-value of peak
    % 'LabelFormat':    Format string for peak labels. Default: '%3.1f'
    % 'MarkerPosition': Position of Markers and Labels. Options are: 'center' (default), 'north', 'south'
    % 'LabelSize':      Size of labels in Points. Default: 14
    
    p = inputParser;
    addRequired(p, 'X');
    addRequired(p, 'Y');
    addOptional(p, 'minPeakDist', 0, @(x)isnumeric(x));
    addOptional(p, 'prominence', rms(Y - mean(Y)), @(x)isnumeric(x));
    addParameter(p, 'ax', []);
    addParameter(p, 'PeakMode', 'max', @(x)(strcmpi(x, 'max') || strcmpi(x, 'min') || strcmpi(x, 'both')));
    addParameter(p, 'LabelPeakMode', 'none');
    addParameter(p, 'LabelFormat', '%3.1f');
    addParameter(p, 'MarkerPosition', 'center');
    addParameter(p, 'MarkerStyle', '.');
    addParameter(p, 'LabelSize', 14);
    
    if ~exist('minPeakDist', 'var')
        minPeakDist = 0;
    end
    
    if ~exist('prominence', 'var')
        prominence = rms(Y - mean(Y));
    end
        
    parse(p,X,Y,minPeakDist, prominence, varargin{:});
    
    X = p.Results.X;
    Y = p.Results.Y;
    minPeakDist = p.Results.minPeakDist;
    prominence = p.Results.prominence;
    PeakMode = p.Results.PeakMode;
    
    % Create figure if necessary
    if isempty(p.Results.ax)
        out.Figure = figure();
        out.ax = axes('parent', out.Figure);
    else
        out.ax = p.Results.ax;
        out.Figure = out.ax.Parent;
    end
    
    hold(out.ax, 'on');
    
    % Plot transparent trace of original data
    alpha = 0.1;
    out.Line  = plot(out.ax, X, Y);
    lineCol = out.Line.Color;
    out.Line.Color = [lineCol alpha];
    
    % Plot peaks
    if strcmpi(PeakMode, 'max') || strcmpi(PeakMode, 'both')
        [out.Peaks.Values, out.Peaks.Locations] = ...
            findpeaks(Y, X, 'MinPeakDistance', minPeakDist, 'MinPeakProminence', prominence, 'MinPeakHeight', mean(Y));
        
        if ~isempty(out.Peaks.Values)
        
        out.PeaksLine = plot(out.ax, out.Peaks.Locations, out.Peaks.Values, ...
            'LineStyle', 'none', 'Marker', p.Results.MarkerStyle, 'MarkerEdgeColor', lineCol, 'MarkerFaceColor', lineCol);
        
        
        savePeakSettings(out.PeaksLine, p.Results);
        out.PeaksLine.Annotation.LegendInformation.IconDisplayStyle = 'off';
        
        if ~strcmpi(p.Results.LabelPeakMode, 'none')
            out.Peaks.Labels = addMarkerLabels(out.PeaksLine, p.Results);
            plotpkmarkersCB(out.PeaksLine, out.Peaks.Labels);
        else
            plotpkmarkersCB(out.PeaksLine, []);
        end
        
        end
    end
    
    % Plot valleys
    if strcmpi(PeakMode, 'min') || strcmpi(PeakMode, 'both')
        [out.Valleys.Values, out.Valleys.Locations] = ...
            findpeaks(-1*Y, X, 'MinPeakDistance', minPeakDist, 'MinPeakProminence', prominence, 'MinPeakHeight', mean(-1*Y));
        
        out.Valleys.Values = -1*out.Valleys.Values;
        out.ValleysLine = plot(out.ax, out.Valleys.Locations, out.Valleys.Values, ...
            'LineStyle', 'none', 'Marker', p.Results.MarkerStyle, 'MarkerEdgeColor', lineCol, 'MarkerFaceColor', lineCol); 
        
        savePeakSettings(out.ValleysLine, p.Results);        
        out.ValleysLine.Annotation.LegendInformation.IconDisplayStyle = 'off';

        
        if ~strcmpi(p.Results.LabelPeakMode, 'none')
            out.Valleys.Labels = addMarkerLabels(out.ValleysLine, p.Results);
            plotpkmarkersCB(out.ValleysLine, out.Valleys.Labels);
        else
            plotpkmarkersCB(out.ValleysLine, []);
        end
    end
end


function labels = addMarkerLabels(markerLine, parserResults)
       
    hAxes = ancestor(markerLine, 'axes');
    
    switch parserResults.LabelPeakMode
        case 'x'
            vals = markerLine.XData;
            
        case 'y'
            vals = markerLine.YData;
    end   
    
    % Add text labels for each point
    for iPk = 1:length(markerLine.YData)
        
        txt = sprintf(parserResults.LabelFormat, vals(iPk));
        
        labels(iPk) = text(hAxes, double(markerLine.XData(iPk)), double(markerLine.YData(iPk)), txt, ...
            'FontSize', parserResults.LabelSize, 'HorizontalAlignment', 'center', 'Tag', 'MarkerLabel');
        
        setappdata(labels(iPk), 'XPos', markerLine.XData(iPk));
        setappdata(labels(iPk), 'YPos', markerLine.YData(iPk));
        setappdata(labels(iPk), 'MarkerPosition', parserResults.MarkerPosition);
    end
    
end


function savePeakSettings(hLine, parserResults)
   setappdata(hLine, 'LabelPeakMode', parserResults.LabelPeakMode);
   setappdata(hLine, 'LabelFormat', parserResults.LabelFormat);
   setappdata(hLine, 'MarkerPosition', parserResults.MarkerPosition);    
end


function labels = shiftMarkersAddLabels(hLine, LabelSize)
%% Helper function used to shift the markers and labels of peaks vertically by the size of these objects
% Based on the function 'plotpkmarkers' by MathWorks


% Fetch the data needed to compute the offset line
y = hLine.YData;
hAxes = ancestor(hLine, 'axes');

axesPos = getpixelposition(hAxes);
yLim = get(hAxes,'YLim');

% bump the line y data by the marker size
yMarkOffset = 2* hLine.MarkerSize * diff(yLim) ./ axesPos(4);
yLabelOffset = 1.2*LabelSize * diff(yLim) ./ axesPos(4);

hLine.YData = hLine.YData+yMarkOffset;
hLine.MarkerFaceColor = hLine.Color;

% Add text labels for each point
for iPk = 1:length(y)
    labels(iPk) = text(hAxes, hLine.XData(iPk), y(iPk)+yMarkOffset+yLabelOffset, sprintf('%4.2f', hLine.XData(iPk)), ...
        'FontSize', LabelSize, 'HorizontalAlignment', 'center');
end

hAxes.YLim(2) = ceil(max(y)+yMarkOffset+yLabelOffset*2);

end

