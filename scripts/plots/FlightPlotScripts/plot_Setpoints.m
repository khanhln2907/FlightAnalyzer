function plot_Setpoints(dataTable)

figure();

%% Plot all setpoints along timeline
ax1 = subplot(3,1,1);
plot(dataTable.FCON_SP_ALL.Time/1e6, dataTable.FCON_SP_ALL.Category, 'x-');

ax2 = subplot(3,1,2);
plot(dataTable.RC_MODE.Time/1e6, dataTable.RC_MODE.ControlMode);
hold on;
yyaxis right;
plot(dataTable.RC_KILLSWITCH.Time/1e6, dataTable.RC_KILLSWITCH.KSState);

ax3 = subplot(3,1,3);
plot(dataTable.FCON_LOG_SP.Time/1e6, dataTable.FCON_LOG_SP.FlightMode);

linkaxes([ax1 ax2 ax3], 'x');


FormatFigure(gcf, 12, 12/8);
end

