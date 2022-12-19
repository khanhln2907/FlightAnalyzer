function plot_FlightMode(dataLOG,c,optionen)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Definition der Plotparameter
X_achse = 'Time [s]';
Y_achse = 'Flight Mode';


Tag_name = 'Flight Mode over Time';
Titel = [Tag_name,' ',dataLOG.Name];


%% Plotten der Parameter

figure('Tag',Tag_name,'name', Tag_name,'Position', c.Pos_Groesse_SVGA);

plot(dataLOG.FCON_SP.Time, dataLOG.FCON_SP.FlightMode,'LineWidth',2);
xlabel(X_achse,'FontSize',c.FS_axes);
ylabel(Y_achse,'FontSize',c.FS_axes);

% set(gca,'XMinorTick','off');
% set(gca,'YMinorTick','off');

grid on;
set(gca,'FontSize',c.FS_plot);
title(Titel,'FontWeight','bold','FontSize',c.FS_title);


figname=[Titel];

%% Speicheroptionen des Plots
if optionen.speichern

% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition', c.Pos_DISS_std);

% saveas(gcf,figname,'jpg')
saveas(gcf,fullfile(optionen.speicherpfad,figname),'jpg');
savefig(fullfile(optionen.speicherpfad,figname));
end

end

