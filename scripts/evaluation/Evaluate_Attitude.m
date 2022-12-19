function [hTurn] = Evaluate_Attitude(dataTable)
        t_interval_sec = [-inf inf]; %[180 200];
        hTurn.Fig = figure('Name', 'Attitude Rates Evaluation');

        nameSensor = "VN200";
        
        tmp = hsv(3); % Get the RGB colors
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        % Plot rates
        hTurn.axP = subplot(3,1,1);
        Plot_Struct_Attitudes(hTurn.axP, dataTable.ATTITUDE.Time / 1e6, dataTable.ATTITUDE.Phi, [], [], "LegendID", nameSensor, "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axP, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.Phi, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
      
        hTurn.axQ = subplot(3,1,2);
        Plot_Struct_Attitudes(hTurn.axQ, dataTable.ATTITUDE.Time / 1e6, [], dataTable.ATTITUDE.Theta,  [], "LegendID", nameSensor, "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axQ, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.Theta, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        
        hTurn.axR = subplot(3,1,3);
        Plot_Struct_Attitudes(hTurn.axR, dataTable.ATTITUDE.Time / 1e6, [], [], dataTable.ATTITUDE.Psi, "LegendID", nameSensor, "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axR, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.Psi, "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        linkaxes([hTurn.axP, hTurn.axQ, hTurn.axR], 'x')
        sgtitle("Attitude", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

end

