close all;

% Trivial time series
fs = 200;
f = 10;

t = 1:1/fs:10;
x = sin(2*pi*f *t);

% TimeSeries instance
rateVn200Info = TSInfo("VN200_p", "deg/s", "p", fs);
rateTs = TimeSeries(t, x, rateVn200Info);

% Functionalities of TS
rateTs.fft_analyze("TimeInterval", [6,8]);

%% Get ts from datasample
dataHandle = load("flight_data_parsed_09-Sep-2022.mat");
dataTable = dataHandle.data_table;

AttTopicInfo.Name = "VN200_Attitude";
AttTopicInfo.Unit = "deg";
AttTopicInfo.fs  = 800;
attTs = Topics2Ts(dataTable, "ATTITUDE", ["Phi", "Theta", "Psi"], AttTopicInfo);

RateTopicInfo.Name = "VN200_AttitudeRate";
RateTopicInfo.Unit = "rad/s";
RateTopicInfo.fs  = 800;
rateTs = Topics2Ts(dataTable, "ATTITUDE_RATE", ["p", "q", "r"], RateTopicInfo);