function out = rearangeAxis(tsArr, tMin, tMax)
        % Pre
        figH = figure();
        
        
        %out.c(1) = uicontrol('style','checkbox','units','pixels',...
        %        'position',[10,30,50,15],'string','yes');

        
        set(figH,'defaultAxesCreateFcn',@axDefaultCreateFcn);
        
%         panel1 = uipanel('Parent',fig);
%         panel2 = uipanel('Parent',panel1);
%         set(panel1,'Position',[0 0 0.95 1]);
%         set(panel2,'Position',[0 -1 1 2]);
%         s = uicontrol('Style','Slider','Parent',1,...
%           'Units','normalized','Position',[0.95 0 0.05 1],...
%           'Value',1,'Callback',{@slider_callback1,panel2});
      
        % Initialized the axes accordingly
        ax(1) = axes('Parent', figH);
        for i = 2:numel(tsArr)
           ax(i) = copyobj(ax(1), figH);
        end
        set(ax(end),'Visible', 'off', 'Box', 'off', 'Tag', 'DummyAxes');

        
        axColors = ColorTable.colormat;
        
        % Plot them and color according to the color table
        tOffset = (tMax - tMin) * 0.1;
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
        set(figH, 'KeyReleaseFcn', {@keyReleasedCb});
        
        set(ax, 'Position', ax(1).Position .* [1 1 0.7 1]);
        for i = 1: numel(tsArr)
            ax(i).YAxis.Color = axColors(i,:);
            ylim(ax(i), ylim(ax(i))); 

            str = sprintf("%s [%s]", tsArr{i}.Info.AxisLabel, tsArr{i}.Info.Unit);
            ylabel(ax(i), str);
        end
        
        axOffset = 15;
        for i = 2: numel(tsArr)
           %ax(i).YTick = linspace(min(ax(i).YTick),max(ax(i).YTick),numel(ax(numel(i)).YTick)); 
           ax(i).YTickLabel = strcat({blanks((i-1)*axOffset)}, ax(i).YTickLabel); 
        end
        
        linkaxes(ax, 'x');

        
        %set(line, "ButtonDownFcn", {@lineButtonDownFcn});
        
        %cursorLine = xline(0,'HitTest','on', 'Parent', ax(2), "LineWidth", 1, "LineStyle", "-.");
        %fig.WindowButtonMotionFcn = @(o,e)WBMF(o,e,ax,cursorLine);       
        %cursorLine.ButtonDownFcn = @(o,e)BDF(o,e,ax,cursorLine);
        
        
%         p = pan(fig);
%         p.ActionPreCallback = @myprecallback;
%         p.ActionPostCallback = @mypostcallback;
%         p.Enable = 'on';
        
        %Create a zoom handle and define the post-callback process
        out.zhndl = zoom; 
        %set(out.zhndl, 'ActionPreCallback',  @zoomPreCb);
        set(out.zhndl, 'ActionPostCallback',  @zoomPostCb);
        out.zhndl.Enable = 'off';

        %Post-callback function  
    
%         for i = 1: numel(ax)
%            addlistener(ax, 'XLim', 'PostSet', @xlimCb); 
%         end
%         

        % Get the toolbar axes
        axToolstrip = axtoolbar(ax(1), 'default');
        % Get the restore view button and reset the callback function
        isRestoreButton = strcmpi({axToolstrip.Children.Icon}, 'restoreview');
        restoreButtonHandle = axToolstrip.Children(isRestoreButton);
        restoreButtonHandle.ButtonPushedFcn = @(~,ev) restoreViewCallback(figH, ev);
        

        out.line = line;
        
        legend;
        out.figH = figH;
end


function axDefaultCreateFcn(hAxes, ~)
    try
        %hAxes.Interactions = [];
        %hAxes.Toolbar = [];
    catch
        %disp("axDefaultCreateFcn failed due to old MATLAB release")
        % ignore - old Matlab release
    end
end

function restoreViewCallback(hAxes, ~)
    try
        disp("RestoredView")
    
    catch
        disp("axDefaultCreateFcn failed due to old MATLAB release")
        % ignore - old Matlab release
    end
end

function zoomPostCb(figH, evt)
    %disp('zoomPostCb is about to occur.');
    %disp(evt)
    
    cah = findall(figH,'type','axes');
    
    
    ax = evt.Axes;
    xBnd = ax.XLim;
    yBnd = ax.YLim;
    
    for i = 1:numel(cah)
        if(~strcmp(cah(i).Tag, 'DummyAxes'))
            set(cah(i),'XLim',xBnd);
        end
    end
    
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
        try
            % Delate DataTip as Childrens of axes
            for i = 1: numel(cah)
                ax = cah(i);
                for j = numel(ax.Children):-1:1
                   if(strcmp(ax.Children(j).Tag, 'TempDataTipMarker'))
                       delete(ax.Children(j));
                   end
                end
            end
        catch
            
        end
            
        try    
            % Delate DataTip found from figures
            dt = findall(figOrg,'type','DataTip');
            for i = numel(dt):-1:1
                delete(dt(i));
            end
        catch
            
        end
        
        disp("Cleared DataTip");
        zoom reset;
    elseif strcmpi(keyPressed,'z')
        for i = 1: numel(cah)
            cah(i);
            zoom(2.0);            
        end
        disp("Zoomed in");
    
    elseif strcmpi(keyPressed,'n')
        disp("Pressed Reset");        
        try
            set(figOrg.Children(1),'XMinorGrid','off');
            set(figOrg.Children(1),'YMinorGrid','off');
            figOrg.Children = figOrg.Children([end 1:end-1]);
        catch
            
        end
        
        while(~strcmp(figOrg.Children(1).Type, "axes"))
            figOrg.Children = figOrg.Children([end 1:end-1]);
        end
        
        try
            set(figOrg.Children(1),'XMinorGrid','on');
            set(figOrg.Children(1),'YMinorGrid','on');
        catch
            
        end
        
        
    elseif strcmpi(keyPressed,'b')
        disp("Pressed Reset");        
        figOrg.Children= figOrg.Children([end 1:end-1]);

        
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
        if(~strcmp(cah(i).Tag, 'DummyAxes'))
            dt = generateDataTip(cah(i), xClicked);        
        end
    end
end

