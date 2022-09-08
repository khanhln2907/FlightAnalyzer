function plot_RCSticks(dataLOG)
%PLOT_RCSWITCHES Adds a plot of the RC switches to the specified axes
%object.
%   Detailed explanation goes here



%% Plot RC stick inputs...
plot([dataLOG.RC_AXES.Time], [dataLOG.RC_AXES.Pitch], 'DisplayName', 'Pitch');
hold on;
plot([dataLOG.RC_AXES.Time], [dataLOG.RC_AXES.Roll], 'DisplayName', 'Roll');
plot([dataLOG.RC_AXES.Time], [dataLOG.RC_AXES.Yaw], 'DisplayName', 'Yaw');
plot([dataLOG.RC_AXES.Time], [dataLOG.RC_AXES.Thrust], 'DisplayName', 'T');
legend('show');
title('RC Stick inputs');
xlabel('Time');
grid on;


end

