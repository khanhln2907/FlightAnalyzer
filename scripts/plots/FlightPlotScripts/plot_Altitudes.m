function plot_Altitudes(ax, dataLOG)
%PLOT_RCSWITCHES Adds a plot of the RC switches to the specified axes
%object.
%   Detailed explanation goes here
fontsize = 30;
legendsize = 20;

POS = dataLOG.POSITION;
POS.Time = POS.Time / 1e6;
LIDAR = dataLOG.LIDAR_GROUND;
LIDAR.Time = LIDAR.Time / 1e6;
AGL = dataLOG.AGL;
AGL.Time = AGL.Time / 1e6;

ax(1) = subplot(211);
plot(ax(1), LIDAR.Time, LIDAR.Distance, 'DisplayName', 'Lidar Distance', 'LineWidth', 2.0);
hold on; grid on;
plot(ax(1), LIDAR.Time, LIDAR.FirstRaw, 'DisplayName', 'FirstRaw');
plot(ax(1), LIDAR.Time, LIDAR.LastRaw, 'DisplayName', 'LastRaw');
plot(ax(1), AGL.Time, AGL.Value, 'DisplayName', 'AGL', 'LineWidth', 2.0);
ylabel(ax(1), 'Lidar/AGL [m]', 'FontSize',fontsize);
xlabel(ax(1), 'Time[s]', 'FontSize',fontsize);

yyaxis(ax(1), 'right');

hasFix = POS.State == 3;

plot(ax(1), POS.Time, POS.Alt, '.', 'DisplayName', 'GPS Altitude');
ylabel(ax(1), 'GPS Altitude',  'FontSize',fontsize);
lgd = legend(ax(1), 'show', 'FontSize',fontsize);
legend(ax(1),'Location', 'northwest', 'FontSize',legendsize);
legend(ax(1), 'show');
title(ax(1), 'Altitudes', 'FontSize',fontsize);
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);


% Create another subplot for Signal Strength
axSS = subplot(212);
plot(axSS, LIDAR.Time, LIDAR.SS1, '--', 'Color', 'c', 'DisplayName', 'Signal Strength 1');
hold on; grid on;
plot(axSS, LIDAR.Time, LIDAR.SS2, '--', 'DisplayName', 'Signal Strength 2');
ylabel(axSS, 'Signal Strength', 'FontSize',fontsize);
xlabel(axSS, 'Time[s]', 'FontSize',fontsize);
legend(axSS,'Location', 'southwest', 'FontSize',legendsize);
legend(axSS, 'show');


end

