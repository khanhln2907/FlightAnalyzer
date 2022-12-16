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
           plot(ax(i), ts.Time, ts.Value, '-o', 'Color', axColors(i,:));  
           
           if(i  == 1)
              hold on; 
           end
        end
        
        % Readjust the axes for readability + beautifulize
        set(ax,'Color', 'None', 'Box', 'off');
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
           %ax(i).YTick = round(linspace(min(ax(i).YTick),max(ax(i).YTick),numel(ax(numel(i)).YTick)),1); 
           ax(i).YTickLabel = strcat({blanks((i-1)*axOffset)}, ax(i).YTickLabel); 
        end
        
        %set(ax(3),'Visible', 'off');
end



