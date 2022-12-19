close all;

%% Files and path declaration
dataFrameK = load(fullfile(pwd,'\FlightLogs\2022-04-13\K4\Parsed_LOG00000.mat'));
dataFrameKC = load(fullfile(pwd,'\FlightLogs\2022-04-13\KC2\Parsed_LOG00002.mat'));
dataFrameKC.dataTable = allign_ADIS(dataFrameKC.dataTable);


AIR_FRAME = "";

%% Data handling
frameK.accSample =  AccelerationSample("K4_VN200_Acceleration", dataFrameK.dataTable.ACCELERATION, 800);
frameK.rateSample =  AttitudeRateSample("K4_VN200_Rate", dataFrameK.dataTable.ATTITUDE_RATE, 800);
frameK.velSample =  VelocitySample("K4_VN200_Velocity", dataFrameK.dataTable.VELOCITY_NED, 1);
frameK.savePath = get_save_path_folder(dataFrameK.dataTable);
mkdir(frameK.savePath);

frameKC.accSample =  AccelerationSample("KC2_VN200_Acceleration", dataFrameKC.dataTable.ACCELERATION, 800);
frameKC.rateSample =  AttitudeRateSample("KC2_VN200_Rate", dataFrameKC.dataTable.ATTITUDE_RATE, 800);
frameKC.velSample =  VelocitySample("KC2_VN200_Velocity", dataFrameKC.dataTable.VELOCITY_NED, 1);
frameKC.savePath = get_save_path_folder(dataFrameKC.dataTable);
frameKC.adisAccSample = AccelerationSample("KC2_ADIS_Acceleration", dataFrameKC.dataTable.ACCELERATION_ADIS_B, 2000);

mkdir(frameKC.savePath);


%%
frameKC.adisAccSample.fft_analyze("TimeInterval", [222, 226]);
frameKC.accSample.fft_analyze("TimeInterval", [222, 226]);

%%
%frameK.accSample.fft_analyze("TimeInterval", [1027, 1030], "SavePath", frameK.savePath);

%%
%% FFT Analysis 
% K4: Hover: [960 - 968]
% Flight to starting points [968 - 984] 
% [5ms]  - [985, 1007]
% [10ms] - [1009 - 1016]
% [15ms] - [1020 - 1032]
% [20ms] - [1032 - 1042]
% Flight Home 5ms [1043 - 1078]
timeKTmp = [961, 971, 990, 1011, 1023, 1035];
frameK.timeAnalysis = [timeKTmp; timeKTmp + 3]';
for i = 1: size(frameK.timeAnalysis, 1)
    tInt = frameK.timeAnalysis(i,:);
    frameK.accSample.fft_analyze("TimeInterval", tInt, "SavePath", frameK.savePath);
    close all;
end

tNonTransient = [968.5, 971.5; 980, 984; 1004, 1007; 1007, 1010; 1016, 1019; 1020, 1024; 1028, 1032; 1032, 1036; 1039, 1042];
for i = 1: size(tNonTransient, 1)
    tInt = tNonTransient(i,:);
    frameK.accSample.fft_analyze("TimeInterval", tInt, "SavePath", frameK.savePath);
    close all;
end


% KC2: Hover: [220 - 233]
% Flight to starting points [233 - 244] 
% [5ms]  - [244 - 264]
% [10ms] - [264 - 276]
% [15ms] - [276 - 289]
% [20ms] - [289 - 299]
% Flight Home 5ms [299 - 330]
timeKCTmp = [225, 235, 250, 268, 279, 293];
frameKC.timeAnalysis = [timeKCTmp; timeKCTmp + 3]';
for i = 1: size(frameKC.timeAnalysis, 1)
    tInt = frameKC.timeAnalysis(i,:);
    frameKC.accSample.fft_analyze("TimeInterval", tInt, "SavePath", frameKC.savePath);
    close all;
end
tNonTransient = [241, 244; 244, 247; 261, 264; 264, 267; 273, 276; 276, 280; 284, 289; 290, 294; 296, 299];
for i = 1: size(tNonTransient, 1)
    tInt = tNonTransient(i,:);
    frameKC.accSample.fft_analyze("TimeInterval", tInt, "SavePath", frameKC.savePath);
    close all;
end



%% ADIS
timeKCTmp = [225, 235, 250, 268, 279, 293];
frameKC.timeAnalysis = [timeKCTmp; timeKCTmp + 3]';
for i = 1: size(frameKC.timeAnalysis, 1)
    tInt = frameKC.timeAnalysis(i,:);
    frameKC.adisAccSample.fft_analyze("TimeInterval", tInt, "SavePath", frameKC.savePath);
    close all;
end
tNonTransient = [241, 244; 244, 247; 261, 264; 264, 267; 273, 276; 276, 280; 284, 289; 290, 294; 296, 299];
for i = 1: size(tNonTransient, 1)
    tInt = tNonTransient(i,:);
    frameKC.adisAccSample.fft_analyze("TimeInterval", tInt, "SavePath", frameKC.savePath);
    close all;
end

    frameKC.adisAccSample.fft_analyze("TimeInterval", [276, 278], "SavePath", frameKC.savePath);

%%
function path = get_save_path_folder(dataTable)
    oldPath = dataTable.evaluation.FilePath;
    tmp = strfind(oldPath, "FlightLogs");
    path = erase(fullfile('.', sprintf("%s", oldPath(tmp:end))), '.mat');
end











