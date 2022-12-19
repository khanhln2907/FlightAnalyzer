function [hTurn] = plotAttitudeRateStruct(ax, rateData, legendName, t_min, t_max)

assert(ismember("Time", rateData.Properties.VariableNames));
assert(ismember("P", rateData.Properties.VariableNames));
assert(ismember("Q", rateData.Properties.VariableNames));
assert(ismember("R", rateData.Properties.VariableNames));
if(~exist(legendName))
   legendName = "Gyro"; 
end


%% Plot rates
hTurn.axRates = ax;
hTurn.LineP = plot(ax, rateData.Time, rateData.P, 'DisplayName', sprintf("P %s", legendName));
hold on;
hTurn.LineQ = plot(ax, rateData.Time, rateData.Q, 'DisplayName', sprintf("Q %s", legendName));
hTurn.LineR = plot(ax, rateData.Time, rateData.R, 'DisplayName', sprintf("R %s", legendName));

%% Info
xlabel(ax, 'Time [s]');
ylabel(ax, 'Rates [rad/s]');
hTurn.LegendRates = legend(ax, 'show');
grid(ax, 'on');
end

