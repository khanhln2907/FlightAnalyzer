get_data;

%%
fc = 50;
fs = 2000;

%frameKC.adisRateSample.plot_time_domain_multi_figure("TimeInterval", [240, 250]);

frameKC.adisFilterredRateSample = copy(frameKC.adisRateSample);
frameKC.adisFilterredRateSample.topic = append(frameKC.adisFilterredRateSample.topic, "_Post_Filterred");
[b,a] = butter(6,fc/(fs/2));
% frameKC.adisFilterredRateSample.data.p = filter(b,a,frameKC.adisRateSample.data.p);
% frameKC.adisFilterredRateSample.data.q = filter(b,a,frameKC.adisRateSample.data.q);  
% frameKC.adisFilterredRateSample.data.r = filter(b,a,frameKC.adisRateSample.data.r);

frameKC.adisFilterredRateSample.data.p = lowpass(frameKC.adisRateSample.data.p, fc, fs);
frameKC.adisFilterredRateSample.data.q = lowpass(frameKC.adisRateSample.data.q, fc, fs);  
frameKC.adisFilterredRateSample.data.r = lowpass(frameKC.adisRateSample.data.r, fc, fs);


% dataIn = frameKC.adisAccSample.data.Ay;
% dataOut = filter(b,a,dataIn);
% 
% fcVN200 = 50;
% [bVn200,aVn200] = butter(6,fcVN200/(800/2));
% dataInVN200 = frameKC.accSample.data.Ay;
% dataOutVN200 = filter(bVn200,aVn200,dataInVN200);



vn200Analyzer = CrossAnalyzerBase({frameKC.rateSample, frameKC.rateFilterredSample});
adisAnalyzer = CrossAnalyzerBase({frameKC.adisRateSample, frameKC.adisFilterredRateSample});
allImuAnalyzer = CrossAnalyzerBase({frameKC.rateSample, frameKC.rateFilterredSample, frameKC.adisFilterredRateSample});


% vn200Analyzer.plot_time_domain_multi_figure("TimeInterval", [240, 250], "SavePath", frameKC.savePath);
% adisAnalyzer.plot_time_domain_multi_figure("TimeInterval", [240, 250], "SavePath", frameKC.savePath);
% allImuAnalyzer.plot_time_domain_multi_figure("TimeInterval", [240, 250], "SavePath", frameKC.savePath);


%%
frameKC.adisFilterredAccSample = copy(frameKC.adisAccSample);
frameKC.adisFilterredAccSample.topic = append(frameKC.adisFilterredAccSample.topic, "_Post_Filterred");
frameKC.adisFilterredAccSample.data.Ax = lowpass(frameKC.adisAccSample.data.Ax, 20, fs);
frameKC.adisFilterredAccSample.data.Ay = lowpass(frameKC.adisAccSample.data.Ay, 20, fs);  
frameKC.adisFilterredAccSample.data.Az = lowpass(frameKC.adisAccSample.data.Az, 20, fs);

frameKC.filterredAccSample = copy(frameKC.accSample);
frameKC.filterredAccSample.topic = append(frameKC.accSample.topic, "_Post_Filterred");
frameKC.filterredAccSample.data.Ax = lowpass(frameKC.accSample.data.Ax, 20, 800);
frameKC.filterredAccSample.data.Ay = lowpass(frameKC.accSample.data.Ay, 20, 800);  
frameKC.filterredAccSample.data.Az = lowpass(frameKC.accSample.data.Az, 20, 800);



vn200AccAnalyzer = CrossAnalyzerBase({frameKC.accSample, frameKC.filterredAccSample});
adisAccAnalyzer = CrossAnalyzerBase({frameKC.adisAccSample, frameKC.adisFilterredAccSample});
allAccAnalyzer = CrossAnalyzerBase({frameKC.accSample, frameKC.filterredAccSample, frameKC.adisFilterredAccSample});




