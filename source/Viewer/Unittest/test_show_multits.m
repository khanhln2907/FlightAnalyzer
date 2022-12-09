close all;

% Trivial time series
fs = 200;
f = 10;

t = 1:1/fs:10;
x = sin(2*pi*f *t);
y = cos(2*pi*f *t);

% TimeSeries instance
pTs = TimeSeries(t, x, TSInfo("VN200_p", "deg/s", "p", fs));
qTs = TimeSeries(t, y, TSInfo("VN200_q", "deg/s", "q", fs));
rTs = TimeSeries(t, y, TSInfo("VN200_r", "deg/s", "r", fs));


% MultiTS Viewer
multiTs = TSViewer([pTs, qTs, rTs]);




