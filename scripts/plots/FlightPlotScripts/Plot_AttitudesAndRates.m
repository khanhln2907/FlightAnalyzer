function [hTurn] = plot_AttitudesAndRates(dataTurn)
%UNTITLED [hTurn] = Plot_AttitudesAndRates(dataTurn)
%   Detailed explanation goes here

hTurn.Fig = figure('Name', 'High speed turn');

% Plot rates
hTurn.axRates = subplot(2,1,1);

plot_Rates(hTurn.axRates, dataTurn);

hTurn.axAttitudes = subplot(2,1,2);

% Plot attitudes
plot_Attitudes(hTurn.axAttitudes, dataTurn);
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);

end

