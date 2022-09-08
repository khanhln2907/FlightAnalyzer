function [hTurn] = Evaluate_Attitude_Rates(dataTable)
        t_interval_sec = [555 568];
        tmp = hsv(3);
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        hTurn.Fig = figure('Name', 'Attitude Rates Evaluation');

        % Plot rates
        hTurn.axP = subplot(3,1,1);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.ATTITUDE_RATE.Time / 1e6, dataTable.ATTITUDE_RATE.p, [], [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, dataTable.FILTERED_ATTITUDE_RATE.p, [], [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.p, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        hTurn.axQ = subplot(3,1,2);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.ATTITUDE_RATE.Time / 1e6, [], dataTable.ATTITUDE_RATE.q,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], dataTable.FILTERED_ATTITUDE_RATE.q, [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.q, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        hTurn.axR = subplot(3,1,3);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.ATTITUDE_RATE.Time / 1e6, [], [], dataTable.ATTITUDE_RATE.r, "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], [], dataTable.FILTERED_ATTITUDE_RATE.r, "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.r, "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        linkaxes([hTurn.axP, hTurn.axQ, hTurn.axR], 'x')

        sgtitle("Attitude Rates", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);

end

