function [hTurn] = plot_Attitudes(ax,dataTable)
assert(isfield(dataTable, "FCON_LOG_SP"));
assert(isfield(dataTable, "ATTITUDE"));

% Amount of setpoints to be plotted along with the sensor values
nMarkers = 400;
Indices = unique(round( linspace(1, numel(dataTable.FCON_LOG_SP.Time), nMarkers)));

%% Phi
hTurn.LinePhi = plot(ax, dataTable.ATTITUDE.Time, dataTable.ATTITUDE.Phi, 'DisplayName', 'Phi Gyro[°]');
hold on;
hTurn.LinePhiSP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.Phi, '.', 'DisplayName', 'Phi SP[°]','MarkerIndices', Indices, 'Color', hTurn.LinePhi.Color);

%% Theta
hTurn.LineTheta = plot(ax, dataTable.ATTITUDE.Time, dataTable.ATTITUDE.Theta, 'DisplayName', 'Theta Gyro[°]');
hTurn.LineThetaSP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.Theta, '.', 'DisplayName', 'Theta SP[°]','MarkerIndices', Indices, 'Color', hTurn.LineTheta.Color);
ylabel(ax, 'Phi/Theta [°]');
xlabel(ax, 'Time [s]');

%% Psi
yyaxis right;
ylabel(ax, 'Heading [°]');
hTurn.LineHeading = plot(ax, dataTable.ATTITUDE.Time, dataTable.ATTITUDE.Psi, 'DisplayName', 'Heading Gyro[°]');
hTurn.LineHeadingSP = plot(ax, dataTable.FCON_LOG_SP.Time, dataTable.FCON_LOG_SP.Psi, '.', 'DisplayName', 'Heading SP[°]','MarkerIndices', Indices, 'Color', hTurn.LineHeading.Color);
legend(ax, 'show');
grid(ax, 'on');
end

