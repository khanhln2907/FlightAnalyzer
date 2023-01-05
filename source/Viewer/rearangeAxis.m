function out = rearangeAxis(tsArr, tMin, tMax)
        % Pre
        fig = figure();
        
        % Initialized the axes accordingly
        ax(1) = axes('Parent', fig);
        for i = 2:numel(tsArr)
           ax(i) = copyobj(ax(1), fig);
        end
        linkaxes(ax,'x');
        axColors = ColorTable.colormat;
        
        % Plot them and color according to the color table
        tOffset = 0; %(tMax - tMin) * 0.1;
        for i = 1:numel(tsArr)
           ts = tsArr{i};
           tFilter =  (ts.Time <= tMax) & (ts.Time >= tMin);
           line(i) = plot(ax(i), ts.Time(tFilter), ts.Value(tFilter), '-o', 'Color', axColors(i,:), "DisplayName", ts.Info.getLegendName);  
           xlim([tMin - tOffset tMax + tOffset]);
           axis manual

           if(i  == 1)
              hold on; 
           end
        end
        
        % Readjust the axes for readability + beautifulize
        set(ax,'Color', 'None', 'Box', 'off');
        set(ax, 'YAxisLocation', 'right');
        set(ax, 'PickableParts', 'all');
        set(ax, 'ButtonDownFcn', {@myAxesCallback});
        set(fig, 'KeyReleaseFcn', {@keyReleasedCb});
        
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
        
        %set(line, "ButtonDownFcn", {@lineButtonDownFcn});
        
        cursorLine = xline(0,'HitTest','on', 'Parent', ax(end), "LineWidth", 2, "LineStyle", "-.");
        fig.WindowButtonMotionFcn = @(o,e)WBMF(o,e,ax,cursorLine);       
        cursorLine.ButtonDownFcn = @(o,e)BDF(o,e,ax,cursorLine);
        
        
        out.line = line;
end

% Interactive Cursor Line
function WBMF(this,evnt,ax,ph)
    ph.Value = ax(end).CurrentPoint(1,1);
end

function BDF(this,evnt,ax,ph)
    fprintf('clicked at x position: %.2f\n',ax(end).CurrentPoint(1,1))
    triggerDatatip(this, ax(end).CurrentPoint(1,1));

end

% The clicked axis is set to be active
function myAxesCallback(src,eventdata)
    
    tmp = eventdata
    src

end


function keyReleasedCb(src,eventdata)
    keyPressed = eventdata.Key;
    if strcmpi(keyPressed,'c')
        figOrg = ancestor(src,'figure');
        cah = findall(figOrg,'type','axes');
        for i = 1: numel(cah)
            ax = cah(i);
            for j = numel(ax.Children):-1:1
               if(strcmp(ax.Children(j).Tag, 'TempDataTipMarker'))
                   delete(ax.Children(j));
               end
            end
        end
        disp("Cleared DataTip");
    elseif strcmpi(keyPressed,'d')
        disp("Pressed D");
    end
    

end


%% Helper function
function triggerDatatip(lineSrc, xClicked)
    % Get all children of figure 
    figOrg = ancestor(lineSrc,'figure');
    cah = findall(figOrg,'type','axes');
        
    for i = 1: numel(cah)
        % store original hold state and return at the end
        ax = cah(i);
        dt = generateDataTip(ax, xClicked);        
    end
end

