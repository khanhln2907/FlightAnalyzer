close all;
format long;
%load('G:\KF048_CUAV_Workspace\flightloganalyzer\FlightLogs\2021-03-16\K1\clean.mat')
%% Data Preprocessing
filePath = 'G:\Workspace\FlightComputer_Analyzer\FlightLogs\2022-03-16\K4\Parsed_LOG00003.mat';
filePath = 'F:\AMDC_Workspace\FlightComputerAnalyzer\FlightLogs\2022-03-16\K4\Parsed_LOG00001.mat';
% Visualize the data for interval selection
dataTable = preprocessing(filePath);

%% Analyze
t_min_s = -inf;
t_max_s = inf;

topic = ["VELOCITY_NED","ATTITUDE_RATE","FILTERED_ATTITUDE_RATE","ATTITUDE","LIDAR_GROUND","AGL","OFS_PMW3901","OFS_THRONE"];
for i = 1:numel(topic)
    data.(topic(i)) =  get_topic_sample_interval(dataTable.(topic(i)), t_min_s, t_max_s);
end
thresOFS = 50;
data.OFS_PMW3901(abs(data.OFS_PMW3901.Dx) > thresOFS | (abs(data.OFS_PMW3901.Dy) > thresOFS),:) = [];
data.OFS_THRONE(abs(data.OFS_THRONE.Dx) > thresOFS | (abs(data.OFS_THRONE.Dy) > thresOFS),:) = [];


show_plots(data)

%% COMPUTATION OF OPTICAL FLOW %%%
% Interpolation to execute online computation for Optical Flow
intplDataThrone = get_related_intpl_ofs_sample(data, data.OFS_THRONE.Time, 'linear');
intplDataPMW = get_related_intpl_ofs_sample(data, data.OFS_PMW3901.Time, 'linear');

selected_ofs_packet = intplDataPMW;

[vxRef, vyRef] = tranVNED2Vb(selected_ofs_packet.VELOCITY_NED.VelNorth, selected_ofs_packet.VELOCITY_NED.VelEast,selected_ofs_packet.VELOCITY_NED.VelDown, selected_ofs_packet.ATTITUDE.Phi, selected_ofs_packet.ATTITUDE.Theta,selected_ofs_packet.ATTITUDE.Psi);
[vxRefOrf, vyRefOrg] = tranVNED2Vb(data.VELOCITY_NED.VelNorth, data.VELOCITY_NED.VelEast,data.VELOCITY_NED.VelDown, ...
                        data.ATTITUDE.Phi, data.ATTITUDE.Theta,data.ATTITUDE.Psi);

pi2rad = pi/180;
[vxOF, vyOF]   = ComputeOF2Vb(selected_ofs_packet.OFS_PMW3901.Dx, selected_ofs_packet.OFS_PMW3901.Dy, selected_ofs_packet.LIDAR_GROUND.Distance, ...
    selected_ofs_packet.ATTITUDE_RATE.p * pi2rad, selected_ofs_packet.ATTITUDE_RATE.q * pi2rad, selected_ofs_packet.ATTITUDE_RATE.r * pi2rad, selected_ofs_packet.Time); 
%[calcVn, calcVe, calcVd] = tranVb2VNED(vxOf, vyOF, zeros(size(vxOf)), data.intplAtt.Phi, data.intplAtt.Theta, data.intplAtt.Psi);

% Post processing the filter data
generate_coeff
lpfir = FIRFilter(coeff_fs100_LP10);
vxOF_filtered = lpfir.compute_time_series(vxOF);
vyOF_filtered = lpfir.compute_time_series(vyOF);

% Optical Flow Evaluation - Velocity comparison
figname = 'Evalutation Optical Flow';
figure('Tag',figname,'name', figname);    
ax(1) = subplot(211);
plot(selected_ofs_packet.Time / 1e6, vxOF, '-o', "DisplayName", "OFS Raw");  % Plot of Interpolation
hold on; grid on; grid minor;
plot(selected_ofs_packet.Time / 1e6, vxOF_filtered, '-o', "DisplayName", "OFS Filtered");  % Plot of Interpolation
plot(selected_ofs_packet.Time / 1e6, vxRef, '-o', "DisplayName", "VN200");                   % Plot of Log
xlabel("Time [s]");
ylabel("v_b x[m/s]");
ylim([-20, 20]);

yyaxis right;
plot(selected_ofs_packet.Time /1e6, selected_ofs_packet.LIDAR_GROUND.LastRaw, '-o', "DisplayName", "Lidar")
ylabel("Raw Lidar [m]");

legend;

ax(2) = subplot(212);
plot(selected_ofs_packet.Time / 1e6, vyOF, '-o', "DisplayName", "OFS Raw");  % Plot of Interpolation
hold on; grid on; grid minor;
plot(selected_ofs_packet.Time / 1e6, vyOF_filtered, '-o', "DisplayName", "OFS Filtered");  % Plot of Interpolation
plot(selected_ofs_packet.Time / 1e6, vyRef, '-o', "DisplayName", "VN200");                   % Plot of Log
xlabel("Time [s]");
ylabel("v_b y [m/s]");
ylim([-20, 20]);

yyaxis right;
plot(selected_ofs_packet.Time /1e6, selected_ofs_packet.LIDAR_GROUND.LastRaw, '-o', "DisplayName", "Lidar")
ylabel("Raw Lidar [m]");
legend;

linkaxes(ax,'x');
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
sgt = title(['Computed Velocities',newline]);
sgt.FontSize = 30;

% Plot the related Parameter:  
% Attitude Rates, Rates
% axAtt = Plot_AttitudesAndRates(dataLOG);
% % Altitude
% altFig = figure;
% axAlt = axes('Position',[0.1 0.1 0.8 0.8]);
% hold on; grid on;
% plot_Altitudes(axAlt, dataLOG, min(time_Int), max(time_Int));

%% SAVE THE RESULT
% folder = dataLOG.Name;
% foldername = ['Sensor Fusion and Signal Processing/Result_' folder];
% if ~exist(foldername, 'dir')
%    mkdir(foldername);
%    addpath(foldername);
%    figName = [foldername '/Motion.fig'];
%    savefig(axMotions, figName);
%    figName = [foldername '/OF.fig'];
%    savefig(axOF, figName);
%    figName = [foldername '/AttitudesandRates.fig'];
%    savefig(axAtt.Fig, figName);
%    figName = [foldername '/Altitudes.fig'];
%    savefig(altFig, figName);
% end
%end

%% SUPPORT FUNCTION
function [Vx, Vy, Vz] = tranVNED2Vb(VN, VE, VD, PhiDeg, ThetaDeg, PsiDeg)
    Phi = PhiDeg * pi/180;
    Theta = ThetaDeg * pi/180;
    Psi = PsiDeg * pi/180;
    
    func = trans_func();
    
    n = numel(VN);
    vOut = zeros(n, 3);
    for i = 1:n
        vOut(i,:) = func.ned_to_body([VN(i), VE(i), VD(i)]', Phi(i), Theta(i), Psi(i));
    end
    Vx = vOut(:,1);
    Vy = vOut(:,2);
    Vz = vOut(:,3);
end




