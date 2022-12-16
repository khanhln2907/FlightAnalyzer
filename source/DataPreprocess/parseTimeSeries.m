function dataTable = parseTimeSeries(dataTable)
    %% Get parsing info    
    [info] = SensorInfo();
    
    %% Sensor Topics
    dataTable = Topics2Ts(dataTable, "ATTITUDE", info.vn200.att);
    dataTable = Topics2Ts(dataTable, "FILTERED_ATTITUDE_RATE", info.vn200.frate);
    dataTable = Topics2Ts(dataTable, "ATTITUDE_RATE", info.vn200.rate);
    dataTable = Topics2Ts(dataTable, "VELOCITY_NED", info.vn200.vel);
    dataTable = Topics2Ts(dataTable, "POSITION", info.vn200.pos);

    % LW20
    dataTable = Topics2Ts(dataTable, "LIDAR_GROUND", info.lw20.ss);
    dataTable = Topics2Ts(dataTable, "LIDAR_GROUND", info.lw20.d);
    aglInfo = TSInfo("LW20", "AGL", "deg/s", "AGL", 249); % !TODO: Some measurements didn't comply to standard ....
    dataTable.LW20_AGL = TimeSeries(dataTable.AGL.Time / 1e6, dataTable.AGL.Value, aglInfo);

%% Flight Setpoints
    dataTable = Topics2Ts(dataTable, "FCON_LOG_SP", info.sp.rate);
    dataTable = Topics2Ts(dataTable, "FCON_LOG_SP", info.sp.att);
    dataTable = Topics2Ts(dataTable, "FCON_LOG_SP", info.sp.vel);
    dataTable = Topics2Ts(dataTable, "FCON_LOG_SP", info.sp.pos);
    
    %% AGL or Altitude
    dataTable = Topics2Ts(dataTable, "FCON_LOG_SP", info.sp.pos);
    
    
end