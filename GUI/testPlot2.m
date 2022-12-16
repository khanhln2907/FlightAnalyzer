t = 1:0.01:10;
x = sin(2 * pi * 1/10 * t);
y = 1000 * cos(2 * pi * 5/10 * t);

ax(1) = plot(t, x);
hold on;

yyaxis right
ax(2) = plot(t, y);

grid on; grid minor;

%%
% Create two identical overlaying axes
fig = figure();
ax1 = axes(); 
ax2 = copyobj(ax1, fig); 
% Link the x axes
linkaxes([ax1,ax2],'x')
% Choose colors for the 2 y axes.
axColors = [
    0        0.39063   0;        % dark green
    0.53906  0.16797   0.88281]; % blue violet
% Do plotting (we'll adjust the axes and the ticks later)
plot(ax1, 1:100, sort(randn(1,100)*100), '-', 'Color', axColors(1,:)); 
plot(ax2, 1:100, sort(randn(1,100)*60), '-', 'Color', axColors(2,:));
% Set axes background color to transparent and turns box on
set([ax1,ax2],'Color', 'None', 'Box', 'on')
% Set y-ax to right side
set([ax1,ax2], 'YAxisLocation', 'right')
% make the axes 10% more narrow
set([ax1,ax2], 'Position', ax1.Position .* [1 1 .90 1]) 
% set the y-axis colors
ax1.YAxis.Color = axColors(1,:); 
ax2.YAxis.Color = axColors(2,:); 
% After plotting set the axis limits. 
ylim(ax1, ylim(ax1)); 
ylim(ax2, ylim(ax2)); 
% Set the y-ticks of ax1 so they align with yticks of ax2
% This also rounds the ax1 ticks to the nearest tenth. 
ax1.YTick = round(linspace(min(ax1.YTick),max(ax1.YTick),numel(ax2.YTick)),1); 
    % Extend the ax1 y-ax ticklabels rightward a bit by adding space
    % to the left of the label.  YTick should be set first. 
    ax1.YTickLabel = strcat({'          '},ax1.YTickLabel);
% Set y-ax labels and adjust their position (5% inward)
ylabel(ax1,'y axis 1')
ylabel(ax2','y axis 2')
ax1.YLabel.Position(1) = ax1.YLabel.Position(1) - (ax1.YLabel.Position(1)*.05); 
ax2.YLabel.Position(1) = ax2.YLabel.Position(1) - (ax2.YLabel.Position(1)*.05); 