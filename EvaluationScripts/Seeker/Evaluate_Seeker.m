%close all;
if(exist('dataTable','var'))
   data = dataTable;    
else
   dataHandle = load('FlightLogs\2022-02-01\K2\Parsed_LOG00003.mat'); 
   data = dataHandle.dataTable;    
end
seeker_info = data.TARGET_INFO;

%% Evaluate all Timestamp
t = seeker_info.TimePacket / 1e6;
dt_cam_ms = diff(seeker_info.TimeCamera) / 1e3;
dt_gimbal_ms = diff(seeker_info.TimeEncoder) / 1e3;

figure
plot(t(1:end-1), dt_cam_ms, '--', "DisplayName", "\Delta t Camera");
hold on; grid on;
plot(t(1:end-1), dt_gimbal_ms, '-', "DisplayName", "\Delta t Encoder");
legend
title("Time difference between samples from MC");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
xlabel("Time [s]");
ylabel("\Delta t [ms]");

%% Evaluate time diff of packet
figure 
ax = axes();
plot_seeker_ts_vs_teensy_ts(ax, data);

%% Evaluate time synchronization and the received frequency of the messages
try
   evaluate_time_synchronization(data);
catch ME
   fprintf("%s", ME.message);
end
%% Plot the time step between encoder's samples
plot_encoder_time_step(data.TARGET_INFO);

%% Plot the time step between camera's samples
plot_camera_time_step(data.TARGET_INFO);


%% Plot the time between Teensy timestamp and encoder timestamp
figure
plot(data.TARGET_INFO.TimePacket / 1e6, data.TARGET_INFO.TimeEncoder / 1e6, "-o", "DisplayName", "Time Encoder")
hold on;
plot(data.TARGET_INFO.TimePacket / 1e6, data.TARGET_INFO.TimePacket / 1e6, "-o", "DisplayName", "Time Logged")
xlabel("Time [s]");
ylabel("Timestamp [s]");
title("Encoder Timestamp");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
legend

%% Plot the time between Teensy timestamp and camera timestamp
figure
histogram((data.TARGET_INFO.TimeEncoder - data.TARGET_INFO.TimeCamera) / 1e3);
hold on;
%plot(data.TARGET_INFO.TimePacket / 1e6, data.TARGET_INFO.TimePacket / 1e6, "*", "DisplayName", "Time Logged")
xlabel("Time [ms]");
ylabel("n");
title("Camera Timestamp");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
legend

%% Plot the encoder 
figure
plot(data.TARGET_INFO.TimeEncoder / 1e6, data.TARGET_INFO.Phi_Enc, "-o", "DisplayName", "phi");
hold on; grid on;
plot(data.TARGET_INFO.TimeEncoder / 1e6, data.TARGET_INFO.Theta_Enc, "-o", "DisplayName", "theta");
plot(data.TARGET_INFO.TimeEncoder / 1e6, data.TARGET_INFO.Psi_Enc, "-o", "DisplayName", "psi");
xlabel("Time [s]");
ylabel("angle [Deg]");
title("Seeker Encoder Samples")
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);



