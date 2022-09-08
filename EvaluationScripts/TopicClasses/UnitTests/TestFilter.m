get_data;

% Create a simple filter instance
myFilter = FilterBase();


%% Frame KC

frameKC.processed.rateVN200 = frameKC.rateSample.lp_filter(myFilter, 50);
frameKC.processed.rateADIS = frameKC.adisRateSample.lp_filter(myFilter, 50);

rateH.FADIS_VN200 = CrossAnalyzerBase({frameKC.rateSample, frameKC.processed.rateADIS});
rateH.FADIS_ADIS = CrossAnalyzerBase({frameKC.adisRateSample, frameKC.processed.rateADIS});
rateH.FADIS_FVN200 = CrossAnalyzerBase({frameKC.processed.rateADIS, frameKC.rateFilterredSample});

%%
rateH.FADIS_VN200.plot_time_domain_single_figure("TimeInterval", [220, 224]);
rateH.FADIS_FVN200.plot_time_domain_single_figure("TimeInterval", [220, 224]);

rateH.FVN200_VN200 = CrossAnalyzerBase({frameKC.rateSample, frameKC.processed.rateVN200});
%% Acceleration
frameKC.processed.accVN200 = frameKC.accSample.lp_filter(myFilter, 10);
frameKC.processed.accADIS = frameKC.adisAccSample.lp_filter(myFilter, 10);

accH.FVN200_VN200 = CrossAnalyzerBase({ frameKC.accSample, frameKC.processed.accVN200});
accH.FADIS_VN200 = CrossAnalyzerBase({ frameKC.accSample, frameKC.processed.accADIS});


accH.FADIS_VN200.plot_time_domain_single_figure("TimeInterval", [232, 236]);
accH.FVN200_VN200.plot_time_domain_single_figure("TimeInterval", [232, 236]);


%% Manual
ax = dataFrameKC.dataTable.ACCELERATION.Ax;
fAx = lowpass(ax, 10, 2000);
figure
plot(ax, '-o')
hold on;
plot(fAx, '-o');

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);










