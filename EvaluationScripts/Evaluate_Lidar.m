function [hTurn] = Evaluate_Lidar(dataTable)
        t_interval_sec = [-inf inf];
        color_map = spring(30);
        
        hTurn.Fig = figure('Name', 'Lidar');
        
        if(isfield(dataTable.LIDAR_GROUND,'FirstRaw') && isfield(dataTable.LIDAR_GROUND,'LastMedian') && isfield(dataTable.LIDAR_GROUND,'LastRaw')) %% 
            hTurn.ax = axes();
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.Distance, dataTable.LIDAR_GROUND.SS, "LegendID", "FirstMedian", "TimeInterval", t_interval_sec);
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.FirstRaw, [],  "LegendID", "FirstRaw", "Color", color_map(1:3,:), "LineStyle", ":", "TimeInterval", t_interval_sec);
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.LastMedian, [], "Color", color_map(15:17,:), "LegendID", "LastMedian", "LineStyle", "--", 'MarkerStyle', '*', "TimeInterval", t_interval_sec);
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.LastRaw, [], "Color", color_map(28:30,:), "LegendID", "LastRaw", "LineStyle", "-.", 'MarkerStyle', '.', "TimeInterval", t_interval_sec);
        elseif (isTableCol(dataTable.LIDAR_GROUND,{'SS1', 'SS2', 'LastRaw'}))
            tmp = hsv(3);
            medianDistanceColor = tmp(1,:);
            firstReturnColor = tmp(2,:);
            secondReturnColor = tmp(3,:);
            
            hTurn.ax = axes();
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.Distance, [],  "LegendID", "Median First", "Color", medianDistanceColor, "TimeInterval", t_interval_sec);
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.FirstRaw, dataTable.LIDAR_GROUND.SS1,  "LegendID", "Raw 1st", "TimeInterval", t_interval_sec, "Color", firstReturnColor);
            Plot_Struct_Lidar(hTurn.ax, dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.LastRaw, dataTable.LIDAR_GROUND.SS2, "Color", secondReturnColor, "LegendID", "Raw 2nd", "TimeInterval", t_interval_sec);
        end
        
        sgtitle("Lidar Measurements", "FontSize", 30);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 10);
end