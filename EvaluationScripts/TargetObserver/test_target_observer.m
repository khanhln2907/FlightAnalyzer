addpath("PlotTools");
addpath("Math");
addpath("FlighLogs");

%close all;
% if(exist('dataTable','var'))
%    data = dataTable;
% else
%    dataHandle = load('FlightLogs\2022-02-01\K2\Parsed_LOG00003.mat'); 
%    data = dataHandle.dataTable;    
% end

path = fullfile(pwd,'Local\2022-09-14\KC3\Processed_LOG00003\MATLAB', "flight_data_parsed_14-Sep-2022 17_51_47.mat"');
dataHandle = get_data_0908(path);
dataAnylzed = dataHandle.dataTable;

%% Perform sample matching and computation of the target info 
% Define the interval of IMU samples executing the mission  
mission_window = (dataAnylzed.ATTITUDE.Time > 309 * 1e6 & dataAnylzed.ATTITUDE.Time < 328 * 1e6);

t_start_s = 309;
t_end_s = 328;

attData = get_topic_sample_interval(dataAnylzed.ATTITUDE, t_start_s, t_end_s);
seekerData = dataHandle.SEEKER.TargetInfo;

%%
enc.Time = seekerData.tEnc;
enc.Phi = seekerData.EncPhi + 2;
enc.Theta = seekerData.EncTheta;
enc.Psi = zeros(size(enc.Time));
encTable = struct2table(enc);
encData = get_topic_sample_interval(encTable, t_start_s, t_end_s);

cam.Time = seekerData.tCam;
cam.Elevation = seekerData.Elevation;
cam.Azimuth = seekerData.Azimuth;
camTable = struct2table(cam);
camData = get_topic_sample_interval(camTable, t_start_s, t_end_s);


% Prepare the samples for the input arguments
sample_att_uav_deg = [attData.Time, attData.Phi, attData.Theta, attData.Psi];
time_shif_gimbal_us = +0.000 * 1e6; % Some fast testing time shift to see the effect of the delay
sample_att_gimbal_deg = [encData.Time, encData.Phi, encData.Theta, encData.Psi];
sample_target_cam_sph_deg = [camData.Time, camData.Azimuth, camData.Elevation];

% Compute all samples 
[sample_target_ned, matched_timestamp] = async_calculate_target_direction(sample_att_uav_deg, sample_att_gimbal_deg, sample_target_cam_sph_deg);

%% Plot encoder attitude vs uav attitude
% figure
% plot( data.TARGET_INFO.TimeEncoder / 1e6, data.TARGET_INFO.Theta_Enc, 'o', "DisplayName", " Encoder Theta");
% hold on; grid on;
% plot( data.TARGET_INFO.TimeCamera / 1e6, data.TARGET_INFO.Elevation, 'o', "DisplayName", "Camera Pitch")
% plot( data.ATTITUDE.Time / 1e6, -data.ATTITUDE.Theta, 'x', "DisplayName", "Negative UAV Pitch")
% xlabel("Time [s]");
% ylabel("Angle [deg]");
% FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
% title("Attitudes")
% legend;

%% Plot the matched timestamp
figure
mismatch_imu_enc_ms = (matched_timestamp(:,1) - matched_timestamp(:,2)) / 1e3;
mismatch_imu_cam_ms = (matched_timestamp(:,1) - matched_timestamp(:,3)) / 1e3;
mismatch_enc_cam_ms = (matched_timestamp(:,2) - matched_timestamp(:,3)) / 1e3;

subplot(311)
plot(sample_target_ned(:,1) / 1e6, mismatch_imu_enc_ms, '-o', "DisplayName", "Imu vs Enc");
hold on; grid on;
legend
subplot(312)
plot(sample_target_ned(:,1) / 1e6, mismatch_imu_cam_ms, '-o', "DisplayName", "Imu vs Cam");
legend
subplot(313)
plot(sample_target_ned(:,1) / 1e6, mismatch_enc_cam_ms, '-o', "DisplayName", "Enc vs Cam");
legend

sgtitle("Time mismatch in ms");
%ylabel("\sigma [ms]")
xlabel("Time [s]")
legend
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

%% Plot the histogram of the matched timestamp
figure

subplot(311)
histogram((mismatch_imu_enc_ms));
legend("Imu vs Enc")
hold on; grid on;
subplot(312)
histogram((mismatch_imu_cam_ms));
legend("Imu vs Cam")
subplot(313)
histogram((mismatch_enc_cam_ms));
legend("Enc vs Cam")
sgtitle("Time mismatch in ms");
%ylabel("\sigma [ms]")
xlabel("dt [ms]")
legend
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

%% Plot the reconstructed target vs the logged target from the flight computer
figure
vel = 15;
line = plot(sample_target_ned(:,1) / 1e6, sample_target_ned(:,2) * vel, '-o', "DisplayName", "Calc North");
hold on; grid on;
plot(dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.VelNorth * vel, '*', "DisplayName", "Logged North", "Color", [1 0 0])

plot(sample_target_ned(:,1) / 1e6, sample_target_ned(:,3) * vel, '-o', "DisplayName", "Calc East");
plot(dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.VelEast * vel, '*', "DisplayName", "Logged East", "Color", [1 0 0])

plot(sample_target_ned(:,1) / 1e6, sample_target_ned(:,4) * vel, '-o', "DisplayName", "Calc Down");
plot(dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, dataAnylzed.FCON_SET_HOMEINGDIRECTION_SIG.VelDown * vel, '*', "DisplayName", "Logged Down", "Color", [1 0 0])
%plot(data. / 1e6, sample_target_ned(:,4) * vel, '-o', "DisplayName", "Calc Down");
title("Computed target vector NED with time correction")
legend
xlabel("Time [s]")
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
