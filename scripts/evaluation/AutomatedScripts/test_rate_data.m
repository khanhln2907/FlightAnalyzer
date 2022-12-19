%
%path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_09-Sep-2022.mat"');
%analyze_rate(path)
%dataTablePath = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_09-Sep-2022.mat"');
dataTablePath = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_12-Sep-2022 06_47_36.mat"');

%%
data = get_data_0908(dataTablePath);

%%
FilterBank
myAnalyzer = FilterredSample();

%% Get the rate data
rateData = AttitudeRateSample("VN200_Rate", data.rawDataTable.ATTITUDE_RATE, 800); 
frateData = data.samples.Sensors.rateFilterredSample; 

%% Apply filter
% filter = rateFilterAMDC_0909;
% filter = rateProposed_ChevII_30_80_25;
% filter = rateProposed_ChevII_40_70_15;
% filter = rateProposed_ChevII_50_80_15;
% filter = rateProposed_ChevII_30_75_25;
% filter = rateProposed_ChevII_40_75_20;
% filter = rateProposed_ChevII_35_75_25;
% filter = rateProposed_ChevII_30_75_25;
% filter = rateProposed_ChevII_30_75_35;

filter = rateProposed_ChevII_40_80_28;

[fpSample, pSample] = myAnalyzer.get_filterred_topic_sample(rateData.get_single_topic_sample("p"), {filter});
[fqSample, qSample] = myAnalyzer.get_filterred_topic_sample(rateData.get_single_topic_sample("q"), {filter});
[frSample, rSample] = myAnalyzer.get_filterred_topic_sample(rateData.get_single_topic_sample("r"), {filter});

%% Plot time domain signal
figure("Name", "Time domain p")
plot(pSample.data.Time, pSample.data.p, "-o", "DisplayName", "p raw");
hold on;
plot(frateData.data.Time, frateData.data.p, "-o", "DisplayName", "logged-fp");
hold on;
plot(fpSample.data.Time, fpSample.data.p, "-o", "DisplayName", "fp");
legend
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
%%
pCrossAnalyzer = CrossAnalyzerBase({pSample, fpSample});
qCrossAnalyzer = CrossAnalyzerBase({qSample, fqSample});
rCrossAnalyzer = CrossAnalyzerBase({rSample, frSample});

%%
tInterval = [680, 690];

rateData.fft_analyze("TimeInterval", tInterval)
frateData.fft_analyze("TimeInterval", tInterval);
fpSample.fft_analyze("TimeInterval", tInterval);
fqSample.fft_analyze("TimeInterval", tInterval);
frSample.fft_analyze("TimeInterval", tInterval);



