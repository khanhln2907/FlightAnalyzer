function plotpkmarkersCB(markerLine, markerLabels)
    %PLOTPKMARKERS  handler to offset peak markers and labels by the size of the marker and labels
    % Note: this is an adapted version of the original, internal matlab function:
    %%
    %
    %   This function is for internal use only.
    %
    %   If the figure zoom ActionPostCallback event cannot be overridden
    %   warn user that we can't override and use (centered) circular markers
    %   for peaks.
    %
    %   Otherwise, use inverted triangular markers and offset them by the size
    %   of the marker, taking care to recompute the offsets upon size change
    %   and figure zoom.
    
    %   Copyright 2014 The MathWorks, Inc.
    %%
    
    if ~isempty(markerLine) && ishghandle(markerLine)
        hFig = ancestor(markerLine,'figure');
        %hAxes = ancestor(markerLine, 'axes');
        hZoom = zoom(hFig);
        cbActionPostZoom = get(hZoom,'ActionPostCallback');
        cbZoom = createZoomCallback();
        if isempty(cbActionPostZoom) || isequal(char(cbActionPostZoom),char(cbZoom))
            % offset markers when figure zoom is invoked.
            if isempty(cbActionPostZoom)
                set(hZoom, 'ActionPostCallback', cbZoom);
            end
            
            % use solid inverted triangular markers
            %     set(markerLine, 'Marker', 'v');
            %     set(markerLine, 'MarkerFaceColor', get(markerLine,'Color'));
            
            labelMode = getappdata(markerLine, 'LabelPeakMode');
            
            
            %parserData = getappdata(hAxes, 'Options');
            
            
            % create callback to offset the peak markers
            setappdata(markerLine, 'YPos', markerLine.YData);
            setappdata(markerLine, 'XPos', markerLine.XData);
            
            cbSizeChange = createSizeChangeCallback(markerLine, markerLabels);
            
            % offset markers on a SizeChange/SizeChanged event.
            if ~isprop(hFig,'TransientSizeChangedListener')
                pi = addprop(hFig,'TransientSizeChangedListener');
                pi.Transient = true;
            end
            ll = event.listener(hFig, 'SizeChanged', cbSizeChange);
            hFig.TransientSizeChangedListener = ll;
            
            %Offset the markers now.
            cbSizeChange(markerLine, markerLabels);
        else
            % zoom post-action callback has already been overridden
            warning(message('signal:findpeaks:CantOffsetPeakMarkers'));
        end
    end
end

function fcn = createSizeChangeCallback(hLine, hLabels)
    fcn = @(obj, evt) offsetPeakMarkers(hLine, hLabels);
end

function fcn = createZoomCallback()
    fcn = @(hFig, hAxes) offsetPeakMarkersByAxes(hFig, hAxes);
end

% offset all peak markers contained within an axes
function offsetPeakMarkersByAxes(~, evt)
    if isfield(evt,'Axes') && ishghandle(evt.Axes)
        hLines = findall(evt.Axes,'Type','line','Tag','Peak');
        hLabels = findall(evt.Axes, 'Type', 'text', 'Tag', 'MarkerLabel');
        for i=1:numel(hLines)           
            offsetPeakMarkers(hLines(i), hLabels);
        end
    end
end

% offset the markers in the line
function offsetPeakMarkers(hLine, hLabels)
    
    % Offset markers
    if ishghandle(hLine)
        % Fetch the data needed to compute the offset line
        y = getappdata(hLine, 'YPos');
        hAxes = ancestor(hLine, 'axes');       
        axesPos = getpixelposition(hAxes);
        
        MarkerPosition =getappdata(hLine, 'MarkerPosition');
        
        switch MarkerPosition
            case 'north'
                direction = 1;
            case 'south'
                direction = -1;
            case 'center'
                direction = 0;
        end
        
        scalePlot(hAxes, direction);
        
        yLim = get(hAxes,'YLim');
        
        
        % bump the line y data by the marker size
        yMarkOffset = 1.4* direction * get(hLine,'MarkerSize') * diff(yLim) ./ axesPos(4);
        yOld = get(hLine, 'YData');
        yNew = y + yMarkOffset;
        if ~isequaln(yOld, yNew)
            set(hLine,'YData', y + yMarkOffset);
        end
        
        
        % Offset labels
        for iLabel = 1:numel(hLabels)
            L = hLabels(iLabel);
            if ishghandle( L)
                y = getappdata(L, 'YPos');
                x = getappdata(L, 'XPos');
                
                yLabelOffset = get(L,'FontSize') * diff(yLim) ./ axesPos(4) + 1.0*yMarkOffset;
                
                PosOld = L.Position;
                PosNew = [x y+yLabelOffset L.Position(3)];
                
                if ~isequal(PosNew,PosOld)
                    L.Position = PosNew;
                end
                
            end
        end
        
    end
    
 
    
    %scalePlot(hAxes);
end




function scalePlot(hAxes, direction)
    
    % In the event that the plot has integer valued y limits, 'axis auto' may
    % clip the YLimits directly to the data with no margin.  We search every
    % line for its max and minimum value and create a temporary annotation that
    % is 10% larger than the min and max values.  We then feed this to "axis
    % auto", save the y limits, set axis to "tight" then restore the y limits.
    % This obviates the need to check each line for its max and minimum x
    % values as well.
    
    minVal = Inf;
    maxVal = -Inf;
    
    hLines = findall(hAxes,'Type','line');
    for i=1:length(hLines)
        data = get(hLines(i),'YData');
        data = data(isfinite(data));
        if ~isempty(data)
            minVal = min(minVal, min(data(:)));
            maxVal = max(maxVal, max(data(:)));
        end
    end
    
    xlimits = xlim(hAxes);
    axis(hAxes, 'auto');
    
    % grow upper and/or lower y extent by 5% (a total of 10%)
    p = .15;
    
    y1 = maxVal;
    y2 = minVal;
    switch direction
        case 1
            y1 = (1+p)*maxVal - p*minVal;
            y2 = minVal;
        case -1
            y1 = maxVal;
            y2 = (1+p)*minVal - p*maxVal;
    end

    
    % artificially expand the data range by the specified amount
    hTempLine = line(xlimits([1 1]),[y1 y2],'Parent',hAxes);
    
    % save the limits
    %ylimits = ylim;
    ylimits = hAxes.YLim;
    delete(hTempLine);
    
    % preserve expanded y limits but tighten x axis.
    axis(hAxes, 'tight');
    ylim(hAxes, ylimits);
    xlim(hAxes, xlimits);
end

