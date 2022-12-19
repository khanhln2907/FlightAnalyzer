function plot_RCSwitches(ax, dataLOG, t_min, t_max)
%PLOT_RCSWITCHES Adds a plot of the RC switches to the specified axes
%object.
%   Detailed explanation goes here

if ~exist('t_min', 'var')
    t_min = min(dataLOG.Receiver.Time);
end

if ~exist('t_max', 'var')
    t_max = max(dataLOG.Receiver.Time);
end

filter = dataLOG.Receiver.Time >= t_min & dataLOG.Receiver.Time <= t_max;


% Plot RC data.
plot(ax, dataLOG.Receiver.Time(filter)/1e6, dataLOG.Receiver.FlightMode(filter), '.', 'DisplayName', 'Mode');
hold on;
plot(ax, dataLOG.Receiver.Time(filter)/1e6, dataLOG.Receiver.KillSwitch(filter), '.', 'DisplayName', 'KillSwitch');
xlabel('Time [s]');
ylabel('Mode / KS [-]');
legend('show');
title('RC Switch positions');


end

