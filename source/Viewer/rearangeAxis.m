function out = rearangeAxis(tsArr, tMin, tMax)
        global axPnt;
        axPnt = 1;
        
        % Pre
        fig = figure('KeyReleaseFcn', {@figKeyReleaseFcn});
            
        % Initialized the axes accordingly
        ax(1) = axes('Parent', fig);
        for i = 2:numel(tsArr)
           ax(i) = copyobj(ax(1), fig);
        end
        linkaxes(ax,'x');
        axColors = ColorTable.colormat;
        
        % Plot them and color according to the color table
        for i = 1:numel(tsArr)
           ts = tsArr{i};
           tFilter =  (ts.Time <= tMax) & (ts.Time >= tMin);
           line(i) = plot(ax(i), ts.Time(tFilter), ts.Value(tFilter), '-o', 'Color', axColors(i,:));  
           
           if(i  == 1)
              hold on; 
           end
        end
        
        % Readjust the axes for readability + beautifulize
        set(ax,'Color', 'None', 'Box', 'on');
        set(ax, 'YAxisLocation', 'right');
        set(ax, 'PickableParts', 'all');
        set(ax, 'HandleVisibility', 'on');
        set(ax, 'ButtonDownFcn', {@myAxesCallback});
        
        set(ax, 'Position', ax(1).Position .* [1 1 (10-numel(tsArr))/10 1]);
        for i = 1: numel(tsArr)
            ax(i).YAxis.Color = axColors(i,:);
            ylim(ax(i), ylim(ax(i))); 

            str = sprintf("%s [%s]", tsArr{i}.Info.AxisLabel, tsArr{i}.Info.Unit);
            ylabel(ax(i), str);
        end
        
        axOffset = 15;
        for i = 2: numel(tsArr)
           ax(i).YTick = linspace(min(ax(i).YTick),max(ax(i).YTick),numel(ax(numel(i)).YTick)); 
           ax(i).YTickLabel = strcat({blanks((i-1)*axOffset)}, ax(i).YTickLabel); 
        end
        
        %set(ax(3),'Visible', 'off');
        pan(fig, 'on');
        set(line, "ButtonDownFcn", {@lineButtonDownFcn});

end

% The clicked axis is set to be active
function myAxesCallback(src,eventdata)
    %uistack(src, 'top');
end

function figKeyReleaseFcn(src, KeyData)
    %disp(KeyData.Character);
    %cah = findall(src,'type','axes');
    %src.Children = [src.Children(end); src.Children(1:end-1)];
end

function lineButtonDownFcn(lineSrc, hit)
    % Responds to mouse clicks on patch objs.
    % Add point at click location and adds a datacursor representing
    % the underlying patch.
    % datatip() requires Matlab r2019b or later
    % Find closet vertices to mouse click
    hitPoint = hit.IntersectionPoint;
    
    [~, minDistIdx] = min((lineSrc.XData - hitPoint(1)).^2);
    
    % Get all children of figure 
    figOrg = ancestor(lineSrc,'figure');
    cah = findall(figOrg,'type','axes');
    
    for i = 1: numel(cah)
        % store original hold state and return at the end
        ax = cah(i);
        axLine =  findall(ax,'type','line', 'tag', '');
        
        holdStates = ["off","on"];
        holdstate = ishold(ax);
        cleanup = onCleanup(@()hold(holdStates(holdstate+1)));
        hold(ax,'on')
        % Search for and destroy previously existing datatips
        % produced by this callback fuction.
        %preexisting = findobj(ax,'Tag','TempDataTipMarker');
        %delete(preexisting)
        
        % Plot temp point at click location and add basic datatip
        x = axLine.XData(minDistIdx);
        y = axLine.YData(minDistIdx);
        
        hh=plot(ax,x, y,'k.','Tag','TempDataTipMarker');
        dt = datatip(hh, x, y,'Tag','TempDataTipMarker');
        dt.DeleteFcn = @(~,~)delete(hh);
        clear cleanup % return hold state
        
        % Update datatip
        pos = hit.IntersectionPoint(1:2);
        hh.DataTipTemplate.DataTipRows(end+1) = ax.YLabel.String;
    end
end

