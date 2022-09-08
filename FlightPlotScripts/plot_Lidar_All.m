function [ ] = plot_Lidar_All(dataLOG, tMin, tMax)

if ~exist('t_min', 'var')
    tMin = min([dataLOG.GPS.Time; dataLOG.Lidar.Time]);
end

if ~exist('t_max', 'var')
    tMax = max([dataLOG.GPS.Time; dataLOG.Lidar.Time]);
end


filter_GPS = dataLOG.GPS.Time >= tMin & dataLOG.GPS.Time <= tMax;
filter_Lidar = dataLOG.Lidar.Time >= tMin & dataLOG.Lidar.Time <= tMax;
ax(1) = subplot(211);
plot(ax(1), dataLOG.Lidar.Time(filter_Lidar), dataLOG.Lidar.Distance(filter_Lidar), 'DisplayName', 'Lidar', 'LineWidth', 2.0);
hold on; grid on;
plot(ax(1), dataLOG.Lidar.Time(filter_Lidar), dataLOG.Lidar.AGL(filter_Lidar), 'DisplayName', 'AGL', 'LineWidth', 2.0);
ylabel(ax(1), 'Lidar/AGL [m]', 'FontSize',fontsize);
xlabel(ax(1), 'Time[s]', 'FontSize',fontsize);

yyaxis(ax(1), 'right');

hasFix = dataLOG.GPS.Lat ~= 0;

plot(ax(1), dataLOG.GPS.Time(filter_GPS), dataLOG.GPS.Alt(filter_GPS), '.', 'DisplayName', 'GPS Altitude');
ylabel(ax(1), 'GPS Altitude',  'FontSize',fontsize);
lgd = legend(ax(1), 'show', 'FontSize',fontsize);
legend(ax(1),'Location', 'northwest', 'FontSize',legendsize);
legend(ax(1), 'show');
title(ax(1), 'Altitudes', 'FontSize',fontsize);
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);


% Create another subplot for Signal Strength
axSS = subplot(212);
plot(axSS, dataLOG.Lidar.Time(filter_Lidar), dataLOG.Lidar.Strength(filter_Lidar), '--', 'Color', 'c', 'DisplayName', 'Signal Strength');
hold on; grid on;
ylabel(axSS, 'Signal Strength', 'FontSize',fontsize);
xlabel(axSS, 'Time[s]', 'FontSize',fontsize);
legend(axSS,'Location', 'southwest', 'FontSize',legendsize);
legend(axSS, 'show');
end

