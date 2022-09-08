%dataFrameKC = load(fullfile(pwd,'FlightLogs\2022-09-01\KC2\Parsed_LOG00006.mat'));
dataFrameKC = load(fullfile(pwd,'FlightLogs\2022-09-07\KC3\Parsed_LOG00002.mat'));


%% Data handling
frameKC.accSample =  AccelerationSample("KC3_VN200_Acceleration", dataFrameKC.dataTable.ACCELERATION, 800);
frameKC.attSample =  AttitudeSample("KC3_VN200_Attitude", dataFrameKC.dataTable.ATTITUDE, 800);
frameKC.rateSample =  AttitudeRateSample("KC3_VN200_Rate", dataFrameKC.dataTable.ATTITUDE_RATE, 800);
frameKC.rateFilterredSample =  AttitudeRateSample("KC3_VN200_Rate_Filterred", dataFrameKC.dataTable.FILTERED_ATTITUDE_RATE, 800);
frameKC.setpoint = dataFrameKC.dataTable.FCON_LOG_SP;
frameKC.targetDirInfo = VelocitySample("KC3_TARGET_DIR", dataFrameKC.dataTable.TARGET_DIRECTION, 120);

%%
targetInfoData.Encoder.Time = dataFrameKC.dataTable.TARGET_INFO.TimeEncoder;
targetInfoData.Encoder.Phi = dataFrameKC.dataTable.TARGET_INFO.Phi_Enc;
targetInfoData.Encoder.Theta = dataFrameKC.dataTable.TARGET_INFO.Theta_Enc;
targetInfoData.Encoder.Psi = dataFrameKC.dataTable.TARGET_INFO.Psi_Enc;
frameKC.gimbalEncSample = AttitudeSample("Gimbal_Enc", targetInfoData.Encoder, 120);

%% Pre parser to comply with the data structure for parsing
calcHomedirection = dataFrameKC.dataTable.FCON_SET_HOMEINGDIRECTION_SIG;
% calcHomedirection.VelNorth = calcHomedirection.VecX;
% calcHomedirection.VelEast = calcHomedirection.VecY;
% calcHomedirection.VelDown = calcHomedirection.VecZ;


%%
trajSample = TrajectorySample("GPSPositionSample", dataFrameKC.dataTable.POSITION, ...
                              "VelNEDSample" , dataFrameKC.dataTable.VELOCITY_NED, ...
                              "AttitudeSample", dataFrameKC.dataTable.ATTITUDE, ...
                              "RateSample", dataFrameKC.dataTable.ATTITUDE_RATE,...
                              "FlightModeSample", dataFrameKC.dataTable.FCON_LOG_SP(:, ["Time", "FlightMode"]),...
                              "GPSSPSample", dataFrameKC.dataTable.FCON_SET_POSITION_SIG,...
                              "TerrainSPSample", dataFrameKC.dataTable.FCON_SET_TERRAIN_SIG, ...
                              "VelNEDSPSample", dataFrameKC.dataTable.FCON_LOG_SP(:, ["Time", "VelNorth", "VelEast", "VelDown"]), ...
                              "TrackingNEDSample", calcHomedirection, ...
                              "TargetInfoSample", dataFrameKC.dataTable.TARGET_INFO);


