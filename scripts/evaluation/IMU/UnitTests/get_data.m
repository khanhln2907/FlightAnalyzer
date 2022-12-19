%% Files and path declaration
dataFrameK = load(fullfile(pwd,'\FlightLogs\2022-04-13\K4\Parsed_LOG00000.mat'));
dataFrameKC = load(fullfile(pwd,'\FlightLogs\2022-04-13\KC2\Parsed_LOG00002.mat'));


dataFrameKC.dataTable = allign_ADIS(dataFrameKC.dataTable);

AIR_FRAME = "";

%% Data handling
frameK.accSample =  AccelerationSample("K4_VN200_Acceleration", dataFrameK.dataTable.ACCELERATION, 800);
frameK.rateSample =  AttitudeRateSample("K4_VN200_Rate", dataFrameK.dataTable.ATTITUDE_RATE, 800);
frameK.rateFilterredSample =  AttitudeRateSample("K4_VN200_Rate_Filterred", dataFrameK.dataTable.FILTERED_ATTITUDE_RATE, 800);
frameK.velSample =  VelocitySample("K4_VN200_Velocity", dataFrameK.dataTable.VELOCITY_NED, 1);
frameK.savePath = get_save_path_folder(dataFrameK.dataTable);
mkdir(frameK.savePath);

frameKC.accSample =  AccelerationSample("KC2_VN200_Acceleration", dataFrameKC.dataTable.ACCELERATION, 800);
frameKC.attSample =  AttitudeSample("KC2_VN200_Attitude", dataFrameKC.dataTable.ATTITUDE, 800);
frameKC.rateSample =  AttitudeRateSample("KC2_VN200_Rate", dataFrameKC.dataTable.ATTITUDE_RATE, 800);
frameKC.rateFilterredSample =  AttitudeRateSample("KC2_VN200_Rate_Filterred", dataFrameKC.dataTable.FILTERED_ATTITUDE_RATE, 800);
frameKC.velSample =  VelocitySample("KC2_VN200_Velocity", dataFrameKC.dataTable.VELOCITY_NED, 1);
frameKC.savePath = get_save_path_folder(dataFrameKC.dataTable);
frameKC.adisAccSample = AccelerationSample("KC2_ADIS_Acceleration", dataFrameKC.dataTable.ACCELERATION_ADIS_B, 2000);
frameKC.adisRateSample = AttitudeRateSample("KC2_ADIS_Rate", dataFrameKC.dataTable.ATTITUDE_RATE_ADIS, 2000);

mkdir(frameKC.savePath);
















function path = get_save_path_folder(dataTable)
    oldPath = dataTable.evaluation.FilePath;
    tmp = strfind(oldPath, "FlightLogs");
    path = erase(fullfile('.', sprintf("%s", oldPath(tmp:end))), '.mat');
end