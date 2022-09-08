function [hTurn] = plot_Rates(ax,dataTable)
assert(isfield(dataTable, "FCON_LOG_SP"));
assert(isfield(dataTable, "ATTITUDE_RATE"));

nMarkers = 200;
Indices = unique(round( linspace(1, numel(dataTable.FCON_LOG_SP.Time), nMarkers)));
%nMarkers = numel(dataTurn.FCON_SP.Time);

%% Plot rates
hTurn.axRates = ax;
%% P
hTurn.LineP = plot(ax, dataTable.ATTITUDE_RATE.Time, dataTable.ATTITUDE_RATE.P, 'DisplayName', 'p Gyro');
hold on;
hTurn.LineP_SP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.P, '.', 'DisplayName', 'p SP', 'MarkerIndices', Indices, 'Color', hTurn.LineP.Color);

%% Q
hTurn.LineQ = plot(ax, dataTable.ATTITUDE_RATE.Time, dataTable.ATTITUDE_RATE.Q, 'DisplayName', 'q Gyro');
hTurn.LineQ_SP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.Q, '.', 'DisplayName', 'q SP', 'MarkerIndices', Indices, 'Color', hTurn.LineQ.Color);

%% R
hTurn.LineR = plot(ax, dataTable.ATTITUDE_RATE.Time, dataTable.ATTITUDE_RATE.R, 'DisplayName', 'r Gyro');
hTurn.LineR_SP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.R, '.', 'DisplayName', 'r SP', 'MarkerIndices', Indices, 'Color', hTurn.LineR.Color);

%% Info
xlabel(ax, 'Time [s]');
ylabel(ax, 'Rates [rad/s]');
hTurn.LegendRates = legend(ax, 'show');
grid(ax, 'on');
end

