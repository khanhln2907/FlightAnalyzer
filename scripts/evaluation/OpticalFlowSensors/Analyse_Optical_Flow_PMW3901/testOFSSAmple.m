filePath = 'F:\AMDC_Workspace\FlightComputerAnalyzer\FlightLogs\2022-03-16\K4\Parsed_LOG00002.mat';
handle = load(filePath);
savePath = "F:\AMDC_Workspace\FlightComputerAnalyzer\FlightLogs\2022-03-16\K4\Parsed_LOG00002";
mkdir(savePath);

pmw3901 = OFSSample("PMW3901", handle.dataTable.OFS_PMW3901, 100);
throneFlow = OFSSample("THRONE", handle.dataTable.OFS_THRONE, 66);
velSample = VelocitySample("Velocity VN200", handle.dataTable.VELOCITY_NED, 200);
attSample = AttitudeSample("Attitude VN200", handle.dataTable.ATTITUDE, 800);
lidarSample = LW20Sample("LW20", handle.dataTable.LIDAR_GROUND, 149);
velBodySample = velSample.to_body_frame(attSample);
rateSample = AttitudeRateSample("AttitudeRate VN200", handle.dataTable.ATTITUDE_RATE, 800);

myAnalyzer = CrossAnalyzerBase({pmw3901, throneFlow});

%%
timeAnalysis = [330, 380];

velSample.plot_time_domain_single_figure_merge("TimeInterval", timeAnalysis, "SavePath", savePath);
myAnalyzer.plot_time_domain_single_figure("TimeInterval", timeAnalysis, "SavePath", savePath);
attSample.plot_time_domain_single_figure("TimeInterval", timeAnalysis, "SavePath", savePath);
lidarSample.plot_time_domain_single_figure_merge("TimeInterval", timeAnalysis, "SavePath", savePath);
velBodySample.plot_time_domain_single_figure_merge("TimeInterval", timeAnalysis, "SavePath", savePath);

%% Analyszer
%ofsAnalyzer = OFSAnalyzer(pmw3901);
%ofsAnalyzer.evaluate_compensate_ofs(rateSample, lidarSample, "TimeInterval", [363, 372], "SavePath", savePath);
%[compOFSSample, disturbances] = ofsAnalyzer.get_compensate_ofs(pmw3901, rateSample, "TimeInterval", [363, 372], "SavePath", savePath);

advCompOfsSample = OFSAnalyzer.get_adv_compensate_ofs(pmw3901, rateSample, "TimeInterval", [363, 372], "SavePath", savePath);
tmp = CrossAnalyzerBase({pmw3901, advCompOfsSample});

%% Processing Velocity
% raw ofs computed
vbOut = advCompOfsSample.compute_vb(rateSample, lidarSample);
vbOut.Time = vbOut.Time * 1e6;
vbOut.Vz = zeros(numel(vbOut.Vx),1);
vbOfs = VelocityBodySample("OFS Computed VelBody", vbOut, 0);

% ofs computed filterred
vbOfsFilterred = vbOut;
vbOfsFilterred.Vx = lowpass(vbOut.Vx, 5, 100);
vbOfsFilterred.Vy = lowpass(vbOut.Vy, 5, 100);
fvbOfsSample = VelocityBodySample("OFS Lp Filterred VelBody", vbOfsFilterred, 0);


%% Evaluate velocity
computedAnalyzer = CrossAnalyzerBase({vbOfs, fvbOfsSample, velBodySample});

%%
computedAnalyzer.plot_time_domain_multi_figure("TimeInterval", [120, 270], "SavePath", savePath);
computedAnalyzer.plot_time_domain_multi_figure("TimeInterval", [320, 370], "SavePath", savePath);
computedAnalyzer.plot_time_domain_multi_figure("TimeInterval", [415, 435], "SavePath", savePath);



lidarSample.plot_time_domain_multi_figure("TimeInterval", [120, 435], "SavePath", savePath);



