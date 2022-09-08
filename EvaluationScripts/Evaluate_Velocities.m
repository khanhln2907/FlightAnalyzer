function [out] = Evaluate_Velocities(dataTable)
%Plots actual GPS velocities and Setpoints, where set.
%   function [out] = plot_Velocities(ax, dataLeg)


figure
out.lineGPS(1) = plot(dataTable.VELOCITY_NED.Time / 1e6, dataTable.VELOCITY_NED.VelNorth, '-o', 'DisplayName', 'V_{North} GPS');
hold on;
out.lineGPS(2) = plot(dataTable.VELOCITY_NED.Time / 1e6, dataTable.VELOCITY_NED.VelEast, '-o', 'DisplayName', 'V_{East} GPS');
out.lineGPS(3) = plot(dataTable.VELOCITY_NED.Time / 1e6, dataTable.VELOCITY_NED.VelDown, '-o', 'DisplayName', 'V_{Down} GPS');

filter = dataTable.FCON_LOG_SP.PrioVelDown > 0;
out.linesSP = plot(dataTable.FCON_LOG_SP.Time(filter) / 1e6, dataTable.FCON_LOG_SP.VelNorth(filter), '-.', 'DisplayName', 'V_{North} SP', 'Color', out.lineGPS(1).Color);
out.linesSP = plot(dataTable.FCON_LOG_SP.Time(filter) / 1e6, dataTable.FCON_LOG_SP.VelEast(filter), '-.', 'DisplayName', 'V_{East} SP', 'Color', out.lineGPS(2).Color);
out.linesSP = plot(dataTable.FCON_LOG_SP.Time(filter) / 1e6, dataTable.FCON_LOG_SP.VelDown(filter), '-.', 'DisplayName', 'V_{Down} SP', 'Color', out.lineGPS(3).Color);

sumV = sqrt(dataTable.VELOCITY_NED.VelNorth.^2 + dataTable.VELOCITY_NED.VelEast.^2 + dataTable.VELOCITY_NED.VelDown.^2);
plot(dataTable.VELOCITY_NED.Time / 1e6, sumV, '-o', 'DisplayName', 'V total');

%out.Legend = legend(ax, 'show', 'Location', 'southoutside', 'orientation', 'horizontal');
out.Legend = legend('show', 'Location','west');
out.XLabel = xlabel('Time [s]');
out.YLabel = ylabel('Velocity [m/s]');
grid('on');

ax = gca;
ax.FontSize = 20;

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

end

