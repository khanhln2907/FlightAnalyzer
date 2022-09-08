function [hTurn] = LidarTreeDetection(dataTable)
        assert (isTableCol(dataTable.LIDAR_GROUND,{'SS1', 'SS2', 'LastRaw'}))
        t_interval_sec = [-inf inf];
        
        distanceDiff = dataTable.LIDAR_GROUND.LastRaw - dataTable.LIDAR_GROUND.FirstRaw;
        reliableThreshold = 80;
        distanceDiffReliable = distanceDiff;
        distanceDiffReliable(dataTable.LIDAR_GROUND.SS1 < reliableThreshold | dataTable.LIDAR_GROUND.SS2 < reliableThreshold) = 0;
        
        
        hTurn.Fig = figure('Name', 'Lidar');
        
        tmp = hsv(3);
        medianDistance = tmp(1,:);
        firstReturnColor = [0 0.4470 0.7410];
        secondReturnColor = [0.4660 0.6740 0.1880];

        color_map = winter(30);
        medianDistance = color_map(1:3,:);
        %firstReturnColor = color_map(10:12,:);
        %secondReturnColor = color_map(20:22,:);
        
        hTurn.ax = axes();
        Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, distanceDiffReliable, [], 'nMarkers', numel(dataTable.LIDAR_GROUND.Time), "LineStyle", "none", "MarkerStyle", "x",  "LegendID", "Reliable Measurement Difference", "Color", [0.9290 0.6940 0.1250], "TimeInterval", t_interval_sec);
        %Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, distanceDiff, [], 'nMarkers', numel(dataTable.LIDAR_GROUND.Time), "LineStyle", "none", "MarkerStyle", "o", "LegendID", "Raw Difference", "Color", firstReturnColor, "TimeInterval", t_interval_sec);
        Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.FirstRaw, dataTable.LIDAR_GROUND.SS1, 'nMarkers', numel(dataTable.LIDAR_GROUND.Time), "LineStyle", "none", "MarkerStyle", ".", "LegendID", "Raw 1st Return", "TimeInterval", t_interval_sec, "Color", firstReturnColor);
        Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.LastRaw, dataTable.LIDAR_GROUND.SS2, 'nMarkers', numel(dataTable.LIDAR_GROUND.Time), "LineStyle", "none", "MarkerStyle", ".", "Color", secondReturnColor, "LegendID", "Raw 2nd Return", "TimeInterval", t_interval_sec);

        % Plot additional Info
        %plot(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.Distance, '-c', "DisplayName", "1st Median");
        %plot(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.State * 10, '.', "DisplayName", "State");
        plot(hTurn.ax, dataTable.AGL.Time / 1e6, dataTable.AGL.Value, '.', "Color", [0.6350 0.0780 0.1840], "DisplayName", "AGL");
          
        sgtitle("Lidar First Return and Last Return Evaluation", "FontSize", 20);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 30);
end

