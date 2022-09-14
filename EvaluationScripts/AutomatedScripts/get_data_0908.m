function [out] = get_data_0908(dataTablePath)

dataHandle = load(dataTablePath);
dataTable = dataHandle.data_table;

out.rawDataTable = dataTable;

% Cleaning data
dataTable = clean_data(dataTable);
%dataTable.SORTED_TARGET_INFO =  get_sorted_target_info(dataTable.TARGET_INFO);

% VN200 data
sampleTable.Sensors.accSample =  AccelerationSample("VN200_Acceleration", dataTable.ACCELERATION, 800);
sampleTable.Sensors.attSample = AttitudeSample("VN200_Attitude", dataTable.ATTITUDE, 800);
sampleTable.Sensors.rateSample =  AttitudeRateSample("VN200_Rate", dataTable.ATTITUDE_RATE, 800);
sampleTable.Sensors.rateFilterredSample =  AttitudeRateSample("VN200_Rate_Filterred", dataTable.FILTERED_ATTITUDE_RATE, 800);
sampleTable.Sensors.velSample =  VelocitySample("VN200_Velocity", dataTable.VELOCITY_NED, 200);

% LW20
sampleTable.Sensors.lidarSample = LW20Sample("LW20", dataTable.LIDAR_GROUND, 150);

% Setpoint
sampleTable.Setpoint.rate =  AttitudeRateSample("FCON_SP_RATE", dataTable.FCON_LOG_SP(:, ["Time", "p", "q", "r"]), 800);
sampleTable.Setpoint.att =  AttitudeSample("FCON_SP_ATT", dataTable.FCON_LOG_SP(:, ["Time", "Phi", "Theta", "Psi"]), 400);
sampleTable.Setpoint.vel = VelocitySample("FCON_SP_VEL", dataTable.FCON_LOG_SP(:, ["Time", "VelNorth", "VelEast", "VelDown"]), 100);
sampleTable.Setpoint.mixer = MixerSample("FCON_SP_MIXER", dataTable.FCON_SET_MIXER_SIG, 50);

dirSP = dataTable.FCON_LOG_SP(:, ["Time", "DirNorth", "DirEast", "DirDown"]);
maxV = dataTable.FCON_LOG_SP(:, ["Time", "DirMaxV"]);
maxV = maxV.DirMaxV;
dirSP.VelNorth = dirSP.DirNorth .* maxV; dirSP.DirNorth = [];
dirSP.VelEast = dirSP.DirEast .* maxV; dirSP.DirEast = [];
dirSP.VelDown = dirSP.DirDown .* maxV; dirSP.DirDown = [];
sampleTable.Setpoint.velDir = VelocitySample("FCON_SP_VEL_DIR", dirSP, 100);
% Handle for animation

% Analyzer
out.samples = sampleTable;
out.dataTable = dataTable;

try
calcHomedirection = dataTable.FCON_SET_HOMEINGDIRECTION_SIG;
targetInfo = dataTable.TARGET_INFO;
out.SEEKER.TargetInfo = get_sorted_target_info(targetInfo);
catch
calcHomedirection = [];    
targetInfo = [];
end

out.flightAnalyzer = TrajectorySample("GPSPositionSample", dataTable.POSITION, ...
                              "VelNEDSample" , dataTable.VELOCITY_NED, ...
                              "AttitudeSample", dataTable.ATTITUDE, ...
                              "RateSample", dataTable.ATTITUDE_RATE,...
                              "FlightModeSample", dataTable.FCON_LOG_SP(:, ["Time", "FlightMode"]),...
                              "GPSSPSample", dataTable.FCON_SET_POSITION_SIG,...
                              "TerrainSPSample", dataTable.FCON_SET_TERRAIN_SIG, ...
                              "VelNEDSPSample", dataTable.FCON_LOG_SP(:, ["Time", "VelNorth", "VelEast", "VelDown"]), ...
                              "TrackingNEDSample", calcHomedirection, ...
                              "TargetInfoSample", targetInfo);

out.rateAnalyzer = CrossAnalyzerBase({sampleTable.Sensors.rateSample, sampleTable.Sensors.rateFilterredSample, sampleTable.Setpoint.rate});
out.attAnalyzer = CrossAnalyzerBase({sampleTable.Sensors.attSample, sampleTable.Setpoint.att});
out.velAnalyzer = CrossAnalyzerBase({sampleTable.Sensors.velSample, sampleTable.Setpoint.velDir, sampleTable.Setpoint.vel});

%% Additional data

end



function dataTable = clean_data(dataTable)
    % Ignore the time after synchronization (normally 30s after starting up)
    dataTable = get_segment_datatable_topic(dataTable, 35, inf);

    % Work around 
    if(isfield(dataTable, "PID_CONTROLLER"))
        dataTable.PID_CONTROLLER = clean_data(dataTable.PID_CONTROLLER);
    end
end


