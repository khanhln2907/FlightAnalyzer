function [out] = plot_Velocities(ax, dataLOG)
%Plots actual GPS velocities and Setpoints, where set.
%   function [out] = plot_Velocities(ax, dataLeg)



out.lineGPS(1) = plot(ax, dataLOG.GPS.Time, dataLOG.GPS.V_north, 'DisplayName', 'V_{North} GPS');
hold on;
out.lineGPS(2) = plot(ax, dataLOG.GPS.Time, dataLOG.GPS.V_east, 'DisplayName', 'V_{East} GPS');
out.lineGPS(3) = plot(ax, dataLOG.GPS.Time, dataLOG.GPS.V_down, 'DisplayName', 'V_{Down} GPS');

filter = dataLOG.FCON_SP.VelD_Prio > 0;
out.linesSP = plot(ax, dataLOG.FCON_SP.Time(filter), dataLOG.FCON_SP.VelN_Value(filter), 'x', 'DisplayName', 'V_{North} SP', 'Color', out.lineGPS(1).Color);
out.linesSP = plot(ax, dataLOG.FCON_SP.Time(filter), dataLOG.FCON_SP.VelE_Value(filter), 'o', 'DisplayName', 'V_{East} SP', 'Color', out.lineGPS(2).Color);
out.linesSP = plot(ax, dataLOG.FCON_SP.Time(filter), dataLOG.FCON_SP.VelD_Value(filter), 'x', 'DisplayName', 'V_{Down} SP', 'Color', out.lineGPS(3).Color);

%out.Legend = legend(ax, 'show', 'Location', 'southoutside', 'orientation', 'horizontal');
out.Legend = legend(ax, 'show', 'Location','west');
out.XLabel = xlabel(ax, 'Time [s]');
out.YLabel = ylabel(ax, 'Velocity [m/s]');
grid('on');
end

