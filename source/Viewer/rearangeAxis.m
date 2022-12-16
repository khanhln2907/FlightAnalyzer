function out = rearangeAxis(tsArr)

    % Pre
        fig = figure();
            
        % Initialized the axes accordingly
        ax(1) = axes();
        for i = 2:numel(tsArr)
           ax(i) = copyobj(ax(1), fig);
        end
        linkaxes(ax,'x');
        axColors = ColorTable.colormat;
        
        % Plot them and color according to the color table
        for i = 1:numel(tsArr)
           ts = tsArr{i};
           plot(ax(i), ts.Time, ts.Value, '-', 'Color', axColors(i,:));  
           
           if(i  == 1)
              hold on; 
           end
        end
        
        % Readjust the axes for readability + beautifulize
        set(ax,'Color', 'None', 'Box', 'on');
        set(ax, 'YAxisLocation', 'right');
        
        set(ax, 'Position', ax(1).Position .* [1 1 (10-numel(tsArr))/10 1]) 
        for i = 1: numel(tsArr)
            ax(i).YAxis.Color = axColors(i,:);
            ylim(ax(i), ylim(ax(i))); 

            str = sprintf("%s [%s]", tsArr{i}.Info.AxisLabel, tsArr{i}.Info.Unit);
            ylabel(ax(i), str);
        end
        
        axOffset = 15;
        for i = 2: numel(tsArr)
           %ax(i).YTick = round(linspace(min(ax(i).YTick),max(ax(i).YTick),numel(ax(numel(tsArr)).YTick)),1); 
           ax(i).YTickLabel = strcat({blanks((i-1)*axOffset)}, ax(i).YTickLabel); 
        end

end


function out = getEmptySpaceStr(n)
    out = string(n,1);
    out(:) = " ";
end

% Create two identical overlaying axes
% fig = figure();
% ax1 = axes(); 
% ax2 = copyobj(ax1, fig); 
% % Link the x axes
% linkaxes([ax1,ax2],'x')
% % Choose colors for the 2 y axes.
% axColors = [
%     0        0.39063   0;        % dark green
%     0.53906  0.16797   0.88281]; % blue violet
% % Do plotting (we'll adjust the axes and the ticks later)
% plot(ax1, 1:100, sort(randn(1,100)*100), '-', 'Color', axColors(1,:)); 
% plot(ax2, 1:100, sort(randn(1,100)*60), '-', 'Color', axColors(2,:));
% % Set axes background color to transparent and turns box on
% set([ax1,ax2],'Color', 'None', 'Box', 'on')
% % Set y-ax to right side
% set([ax1,ax2], 'YAxisLocation', 'right')
% % make the axes 10% more narrow
% set([ax1,ax2], 'Position', ax1.Position .* [1 1 .90 1]) 
% % set the y-axis colors
% ax1.YAxis.Color = axColors(1,:); 
% ax2.YAxis.Color = axColors(2,:); 

% % After plotting set the axis limits. 
% ylim(ax1, ylim(ax1)); 
% ylim(ax2, ylim(ax2)); 
% % Set the y-ticks of ax1 so they align with yticks of ax2
% % This also rounds the ax1 ticks to the nearest tenth. 
% ax1.YTick = round(linspace(min(ax1.YTick),max(ax1.YTick),numel(ax2.YTick)),1); 
% % Extend the ax1 y-ax ticklabels rightward a bit by adding space
% % to the left of the label.  YTick should be set first. 
%     ax1.YTickLabel = strcat({'          '},ax1.YTickLabel);
% % Set y-ax labels and adjust their position (5% inward)
% ylabel(ax1,'y axis 1')
% ylabel(ax2','y axis 2')
% ax1.YLabel.Position(1) = ax1.YLabel.Position(1) - (ax1.YLabel.Position(1)*.05); 
% ax2.YLabel.Position(1) = ax2.YLabel.Position(1) - (ax2.YLabel.Position(1)*.05); 

