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