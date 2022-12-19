get_data;
myAnalyzer = FilterredSample();

%% Acceleration Filtering
FilterBank;
accSampleSegment = frameKC.adisAccSample.get_data_segments(243, 246); % 194.2, 194.8
accXSample = accSampleSegment.get_single_topic_sample("Ax");
accYSample = accSampleSegment.get_single_topic_sample("Ay");

% [fAccSample4, orgSample4] = myAnalyzer.get_filterred_topic_sample(accSampleSegment, {myFilter4, myFilter4, myFilter4});
% [fAccSample5, orgSample5] = myAnalyzer.get_filterred_topic_sample(accSampleSegment, {myFilter5, myFilter5, myFilter5});

[fAccXSample4, orgSample4] = myAnalyzer.get_filterred_topic_sample(accXSample, {myFilter4});
[fAccXSample5, orgSample5] = myAnalyzer.get_filterred_topic_sample(accXSample, {myFilter5});
[fAccXSample6, orgSample6] = myAnalyzer.get_filterred_topic_sample(accXSample, {myFilter6});
[fAccXSample7, orgSample7] = myAnalyzer.get_filterred_topic_sample(accXSample, {myFilter7});
fAccXSampleIdeal = copy(accXSample);
%fAccXSampleIdeal.data.Ax = lowpass(accXSample.data.Ax, 25, 2000);
fAccXSampleIdeal = fAccXSampleIdeal.get_single_topic_sample("Ax");
fAccXSampleIdeal.topic = "KC2_ADIS_Acceleration_a_x_Ideal_Filterred";

% Cross analyzer
analyzer = CrossAnalyzerBase({accXSample, fAccXSampleIdeal, fAccXSample4, fAccXSample5, fAccXSample6, fAccXSample7});
analyzer2 = CrossAnalyzerBase({accXSample, fAccXSampleIdeal, fAccXSample4, fAccXSample5, fAccXSample6});

%% Attituderate Filtering
FilterBank; % Reset filters
rateSampleSegment = frameKC.adisRateSample.get_data_segments(-inf, inf); % 194.2, 194.8
rateQSample = rateSampleSegment.get_single_topic_sample("q");
rateVn200SampleSegment = frameKC.rateSample.get_data_segments(-inf, inf); % 194.2, 194.8
rateVn200SampleSegment = rateVn200SampleSegment.get_single_topic_sample("q");

%%
vn200Filterred = frameKC.rateFilterredSample;
[fRateXSample4, orgSample4] = myAnalyzer.get_filterred_topic_sample(rateQSample, {myFilter4});
[fRateXSample5, orgSample5] = myAnalyzer.get_filterred_topic_sample(rateQSample, {myFilter5});
[fRateXSample6, orgSample6] = myAnalyzer.get_filterred_topic_sample(rateQSample, {myFilter6});
[fRateXSample7, orgSample7] = myAnalyzer.get_filterred_topic_sample(rateQSample, {myFilter7});
[fRateXSample9, orgSample9] = myAnalyzer.get_filterred_topic_sample(rateVn200SampleSegment, {myFilter9});

%%
fRateQSampleIdeal = copy(rateQSample);
fRateQSampleIdeal.data.q = lowpass(rateQSample.data.q, 20, 2000);
fRateQSampleIdeal.topic = "KC2_ADIS_Rate_q_Ideal_Filterred";
fRateVn200Sample = vn200Filterred.get_single_topic_sample("q");
analyzer3 = CrossAnalyzerBase({rateQSample, fRateVn200Sample, fRateXSample4, fRateXSample5, fRateXSample6, fRateXSample9});
analyzer4 = CrossAnalyzerBase({rateQSample, fRateQSampleIdeal, fRateVn200Sample, fRateXSample4, fRateXSample5, fRateXSample6});







