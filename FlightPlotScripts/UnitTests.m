function UnitTests(dataTable, testID)
    
    %% Test 1: Attitude Rates - Plot each data type indepently
    if(testID == 1) 
        t_interval_sec = [70 260];
        tmp = hsv(3);
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        figure(1)
        ax1 = axes();
        Plot_Struct_Attitudes_Rate(ax1, dataTable.ATTITUDE_RATE.Time / 1e6, dataTable.ATTITUDE_RATE.P, [], [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(ax1, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, dataTable.FILTERED_ATTITUDE_RATE.P, [], [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(ax1, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.P, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);

        figure(2)
        ax2 = axes();
        Plot_Struct_Attitudes_Rate(ax2, dataTable.ATTITUDE_RATE.Time / 1e6, [], dataTable.ATTITUDE_RATE.Q,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(ax2, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], dataTable.FILTERED_ATTITUDE_RATE.Q, [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(ax2, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.Q, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);

        figure(3)
        ax3 = axes();
        Plot_Struct_Attitudes_Rate(ax3, dataTable.ATTITUDE_RATE.Time / 1e6, [], [], dataTable.ATTITUDE_RATE.R, "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(ax3, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], [], dataTable.FILTERED_ATTITUDE_RATE.R, "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(ax3, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.R, "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);
    end

    %% Test 2 Attitude Rates - Merge all axes into 1 plot
    if(testID == 2)
        t_interval_sec = [200 1000];
        tmp = hsv(3);
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        hTurn.Fig = figure('Name', 'Attitude Rates Evaluation');

        % Plot rates
        hTurn.axP = subplot(3,1,1);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.ATTITUDE_RATE.Time / 1e6, dataTable.ATTITUDE_RATE.P, [], [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, dataTable.FILTERED_ATTITUDE_RATE.P, [], [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axP, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.P, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        hTurn.axQ = subplot(3,1,2);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.ATTITUDE_RATE.Time / 1e6, [], dataTable.ATTITUDE_RATE.Q,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], dataTable.FILTERED_ATTITUDE_RATE.Q, [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axQ, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.Q, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        hTurn.axR = subplot(3,1,3);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.ATTITUDE_RATE.Time / 1e6, [], dataTable.ATTITUDE_RATE.R,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec, "Color", color_real);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, [], dataTable.FILTERED_ATTITUDE_RATE.R, [], "LineStyle", "--", "Color", color_filtered, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(hTurn.axR, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.R, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        sgtitle("Attitude Rates", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);
    end
    
    %% Test 3: Attitude  - Plot each data type indepently
    if(testID == 3) 
        t_interval_sec = [500 1000];
        
        tmp = hsv(3);
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        figure(1)
        ax1 = axes();
        Plot_Struct_Attitudes(ax1, dataTable.ATTITUDE.Time / 1e6, dataTable.ATTITUDE.Phi, [], [],"Color", color_real, "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(ax1, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.Phi, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

        figure(2)
        ax2 = axes();
        Plot_Struct_Attitudes(ax2, dataTable.ATTITUDE.Time / 1e6, [], dataTable.ATTITUDE.Theta,  [],"Color", color_real, "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(ax2, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.Theta, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

        figure(3)
        ax3 = axes();
        Plot_Struct_Attitudes(ax3, dataTable.ATTITUDE.Time / 1e6, [], [], dataTable.ATTITUDE.Psi,"Color", color_real, "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(ax3, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.Psi, "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    end
    
    %% Test 4 Attitude - Merge all axes into 1 plot
    if(testID == 4)
        t_interval_sec = [120 360];
        hTurn.Fig = figure('Name', 'Attitude Rates Evaluation');

        tmp = hsv(3);
        color_SP = tmp(1,:); % R
        color_filtered = tmp(2,:); % G
        color_real = tmp(3,:);%B
        
        % Plot rates
        hTurn.axP = subplot(3,1,1);
        Plot_Struct_Attitudes(hTurn.axP, dataTable.ATTITUDE.Time / 1e6, dataTable.ATTITUDE.Phi, [], [], "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axP, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.Phi, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
      
        hTurn.axQ = subplot(3,1,2);
        Plot_Struct_Attitudes(hTurn.axQ, dataTable.ATTITUDE.Time / 1e6, [], dataTable.ATTITUDE.Theta,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axQ, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.Theta, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        
        hTurn.axR = subplot(3,1,3);
        Plot_Struct_Attitudes(hTurn.axR, dataTable.ATTITUDE.Time / 1e6, [], [], dataTable.ATTITUDE.Psi, "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes(hTurn.axR, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.Psi, "LineStyle", "none", 'MarkerStyle', '.', "Color", color_SP, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        
        sgtitle("Attitude", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    end
    
    %% Test 5 Attitude Rates - Plot filtered value and setpoint values to evaluate control loop
    if(testID == 5)
        t_interval_sec = [120 360];
        
        figure
        ax1 = axes();
        Plot_Struct_Attitudes_Rate(ax1, dataTable.FILTERED_ATTITUDE_RATE.Time / 1e6, dataTable.FILTERED_ATTITUDE_RATE.P,  dataTable.FILTERED_ATTITUDE_RATE.Q,  dataTable.FILTERED_ATTITUDE_RATE.R, "LegendID", "Filtered", "TimeInterval", t_interval_sec);
        Plot_Struct_Attitudes_Rate(ax1, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.P, dataTable.FCON_LOG_SP.Q, dataTable.FCON_LOG_SP.R, "LineStyle", "none", 'nMarkers', 100, 'MarkerStyle', '.', "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
                
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 8);
    end
    
    %% Test 6: Plot Velocities
    if(testID == 6)
        t_interval_sec = [120 360];
        hTurn.Fig = figure('Name', 'Attitude Rates Evaluation');
        spColor = [1 0 0]; % Red
        
        % Plot rates
        hTurn.velN = subplot(3,1,1);
        Plot_Struct_Velocities(hTurn.velN, dataTable.VELOCITY_NED.Time / 1e6, dataTable.VELOCITY_NED.VelNorth, [], [], "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Velocities(hTurn.velN, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.VelNorth, [], [], "LineStyle", "none", 'MarkerStyle', '.', "Color", spColor, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
      
        hTurn.velE = subplot(3,1,2);
        %% NAME OF VEL EAST VARIABLE MUST BE UPDATED
        Plot_Struct_Velocities(hTurn.velE, dataTable.VELOCITY_NED.Time / 1e6, [], dataTable.VELOCITY_NED.VelEast,  [], "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Velocities(hTurn.velE, dataTable.FCON_LOG_SP.Time / 1e6, [], dataTable.FCON_LOG_SP.VelEasr, [], "LineStyle", "none", 'MarkerStyle', '.', "Color", spColor, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        
        hTurn.velD = subplot(3,1,3);
        Plot_Struct_Velocities(hTurn.velD, dataTable.VELOCITY_NED.Time / 1e6, [], [], dataTable.VELOCITY_NED.VelDown, "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Velocities(hTurn.velD, dataTable.FCON_LOG_SP.Time / 1e6, [], [], dataTable.FCON_LOG_SP.VelDown, "LineStyle", "none", 'MarkerStyle', '.', "Color", spColor, "LegendID", "SetPoint", "TimeInterval", t_interval_sec);
        
        sgtitle("Velocities", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    end
    
    %% Test 7: Plot Velocities subplots
    if(testID == 7)
        t_interval_sec = [120 360];
        hTurn.Fig = figure('Name', 'Velocity');

        % Plot velocity         %% NAME OF VEL EAST VARIABLE MUST BE UPDATED
        hTurn.ax = axes();
        Plot_Struct_Velocities(hTurn.ax, dataTable.VELOCITY_NED.Time / 1e6, dataTable.VELOCITY_NED.VelNorth, dataTable.VELOCITY_NED.VelEast, dataTable.VELOCITY_NED.VelDown, "Color", hsv(3), "LegendID", "VN200", "TimeInterval", t_interval_sec);
        Plot_Struct_Velocities(hTurn.ax, dataTable.FCON_LOG_SP.Time / 1e6, dataTable.FCON_LOG_SP.VelNorth, dataTable.FCON_LOG_SP.VelEasr, dataTable.FCON_LOG_SP.VelDown, "LineStyle", "none", 'MarkerStyle', '.', "Color", hsv(3), "LegendID", "SetPoint", "TimeInterval", t_interval_sec);

        sgtitle("NED Velocities", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 6);
    end
    
    %% Test 8: Plot Lidar subplots
    if(testID == 8)
        t_interval_sec = [0 350];
        hTurn.Fig = figure('Name', 'Lidar');

        % Plot velocity         %% NAME OF VEL EAST VARIABLE MUST BE UPDATED
        hTurn.ax = axes();
        %Plot_Struct_Lidar(hTurn.ax, outTable.LIDAR_GROUND.Time / 1e6, outTable.LIDAR_GROUND.Distance, outTable.LIDAR_GROUND.SS, "LegendID", "FirstMedian", "Color", color_Filtered, "TimeInterval", t_interval_sec);
        Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.FirstRaw, dataTable.LIDAR_GROUND.SS, "LegendID", "FirstRaw", "Color", winter(3), "TimeInterval", t_interval_sec);
        %Plot_Struct_Lidar(hTurn.ax, outTable.LIDAR_GROUND.Time / 1e6, outTable.LIDAR_GROUND.LastMedian, [], "LegendID", "LastMedian", "LineStyle", "-", 'MarkerStyle', '*', "TimeInterval", t_interval_sec);
        Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.LastRaw, [], "Color", autumn(3), "LegendID", "LastRaw", "LineStyle", "--", "TimeInterval", t_interval_sec);

        sgtitle("Lidar Measurements", "FontSize", 10);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    end
end
















