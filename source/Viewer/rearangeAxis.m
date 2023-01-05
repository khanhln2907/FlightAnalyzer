function out = rearangeAxis(tsArr, tMin, tMax)
        % Pre
        fig = figure();
        
        set(fig,'defaultAxesCreateFcn',@axDefaultCreateFcn);
        
%         panel1 = uipanel('Parent',fig);
%         panel2 = uipanel('Parent',panel1);
%         set(panel1,'Position',[0 0 0.95 1]);
%         set(panel2,'Position',[0 -1 1 2]);
%         s = uicontrol('Style','Slider','Parent',1,...
%           'Units','normalized','Position',[0.95 0 0.05 1],...
%           'Value',1,'Callback',{@slider_callback1,panel2});
      
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
        for i = 1:numel(ax)
           tb = axtoolbar(ax(i),{'pan'}); % TODO: Check version matlab here
           disableDefaultInteractivity(ax(i));
        end
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
        
        
%         p = pan(fig);
%         p.ActionPreCallback = @myprecallback;
%         p.ActionPostCallback = @mypostcallback;
%         p.Enable = 'on';
        
        %Create a zoom handle and define the post-callback process
        out.zhndl = zoom; 
        %set(out.zhndl, 'ActionPreCallback',  @zoomPreCb);
        set(out.zhndl, 'ActionPostCallback',  @zoomPostCb);
        %Post-callback function  


        
        out.line = line;
end

function axDefaultCreateFcn(hAxes, ~)
    try
        hAxes.Interactions = [zoomInteraction regionZoomInteraction rulerPanInteraction];
        hAxes.Toolbar = [];
    catch
        disp("Shit")
        % ignore - old Matlab release
    end
end

function zoomPreCb(h, eventdata)  
        disp('zoomPreCb is about to occur.');
        disp(eventdata)
end

function zoomPostCb(h, eventdata)
    disp('zoomPostCb is about to occur.');
    disp(eventdata)
end

function mypostcallback(obj,evd)
    newLim = evd.Axes.XLim;
    disp(sprintf('The new X-Limits are [%.2f,%.2f].',newLim));
end

function slider_callback1(src,eventdata,arg1)
val = get(src,'Value');
set(arg1,'Position',[0 -val 1 2])
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
    figOrg = ancestor(src,'figure');   
    cah = findall(figOrg,'type','axes');
    
    if strcmpi(keyPressed,'c')
        for i = 1: numel(cah)
            ax = cah(i);
            for j = numel(ax.Children):-1:1
               if(strcmp(ax.Children(j).Tag, 'TempDataTipMarker'))
                   delete(ax.Children(j));
               end
            end
        end
        disp("Cleared DataTip");
        zoom reset;
    elseif strcmpi(keyPressed,'z')
        for i = 1: numel(cah)
            cah(i);
            zoom(2.0);            
        end
        disp("Zoomed in");
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

