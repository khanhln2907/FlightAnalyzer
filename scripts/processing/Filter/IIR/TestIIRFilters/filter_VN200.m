get_data;

%%
fc = 20;
fs = 2000;

[b,a] = butter(6,fc/(fs/2));
dataIn = frameKC.adisAccSample.data.Ay;
dataOut = filter(b,a,dataIn);

fcVN200 = 50;
[bVn200,aVn200] = butter(6,fcVN200/(800/2));
dataInVN200 = frameKC.accSample.data.Ay;
dataOutVN200 = filter(bVn200,aVn200,dataInVN200);


figure
plot(frameKC.adisAccSample.data.Time, dataIn);
hold on; grid on;
plot(frameKC.adisAccSample.data.Time, dataOut);
plot(frameKC.accSample.data.Time, -dataOutVN200);

legend()

