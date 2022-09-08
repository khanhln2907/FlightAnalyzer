dataFrameKC = load(fullfile(pwd,'FlightLogs\2022-08-30\KC3\Parsed_LOG00005.mat'));


%% Data handling
frameKC.accSample =  AccelerationSample("KC3_VN200_Acceleration", dataFrameKC.dataTable.ACCELERATION, 800);
frameKC.attSample =  AttitudeSample("KC3_VN200_Attitude", dataFrameKC.dataTable.ATTITUDE, 800);
frameKC.rateSample =  AttitudeRateSample("KC3_VN200_Rate", dataFrameKC.dataTable.ATTITUDE_RATE, 800);
frameKC.rateFilterredSample =  AttitudeRateSample("KC3_VN200_Rate_Filterred", dataFrameKC.dataTable.FILTERED_ATTITUDE_RATE, 800);
frameKC.setpoint = dataFrameKC.dataTable.FCON_LOG_SP;
frameKC.targetDirInfo = VelocitySample("KC3_TARGET_DIR", dataFrameKC.dataTable.TARGET_DIRECTION, 120);

%%
targetInfoData.Encoder.Time = dataFrameKC.dataTable.TARGET_INFO.TimeEncoder;
targetInfoData.Encoder.Phi = dataFrameKC.dataTable.TARGET_INFO.Phi_Enc;
targetInfoData.Encoder.Theta = dataFrameKC.dataTable.TARGET_INFO.Theta_Enc;
targetInfoData.Encoder.Psi = dataFrameKC.dataTable.TARGET_INFO.Psi_Enc;
frameKC.gimbalEncSample = AttitudeSample("Gimbal_Enc", targetInfoData.Encoder, 120);

%% Cross Analysis
figure
spHandle = dataFrameKC.dataTable.FCON_LOG_SP;
plot(spHandle.Time / 1e6, spHandle.Psi, '-o', "DisplayName", "Psi");
hold on; grid on;
plot(spHandle.Time / 1e6, spHandle.PrioPsi_dot, '-o', "DisplayName", "Psi_dot");
plot(targetInfoData.Encoder.Time / 1e6, targetInfoData.Encoder.Phi, '-o', "DisplayName", "Enc Phi");
plot(targetInfoData.Encoder.Time / 1e6, targetInfoData.Encoder.Theta, '-o', "DisplayName", "Enc Theta");
plot(targetInfoData.Encoder.Time / 1e6, targetInfoData.Encoder.Psi, '-o', "DisplayName", "Enc Psi");

yyaxis right;
hold on; grid on;
plot(spHandle.Time / 1e6, spHandle.FlightMode, '-o');
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')

legend
 

%% Plot Attitude vs Hoeming
figure
ax(1) = subplot(211);
plot(frameKC.attSample.data.Time, frameKC.attSample.data.Phi, '-o', "DisplayName", "UAV phi");
hold on;
plot(frameKC.attSample.data.Time, frameKC.attSample.data.Theta, '-o', "DisplayName", "UAV theta");

yyaxis right;
plot(frameKC.attSample.data.Time, frameKC.attSample.data.Psi, '-o', "DisplayName", "UAV psi");
title("Attitude")
ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(2) = subplot(212);
plot(spHandle.Time / 1e6, spHandle.FlightMode, '-o', "DisplayName", "FlightMode", "Color", "blue");
ylabel("Mode");
hold on; grid on;
yyaxis right;
plot(spHandle.Time / 1e6, spHandle.PrioPsi, '-o', "DisplayName", "Prio Psi");
plot(spHandle.Time / 1e6, spHandle.PrioPsi_dot, '--o', "DisplayName", "Prio Psi_dot", "Color", "black");
plot(spHandle.Time / 1e6, spHandle.Prior, '-.*', "DisplayName", "Prio r", "Color", "yellow");
ylabel("Prio");
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')
legend("Interpreter", "none")
xlabel("Time [s]");

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);

linkaxes(ax,'x');
legend

%% Plot Rate vs Hoeming
figure
ax(1) = subplot(311);
plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.p * 180 / pi, '-o', "DisplayName", "UAV p");
hold on; grid on;

plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.q * 180 / pi, '-o', "DisplayName", "UAV q");
plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.r * 180 / pi, '-o', "DisplayName", "UAV r");

title("Rate")
ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(2) = subplot(312);

plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.p * 180 / pi, '-o', "DisplayName", "UAV f p");
hold on; grid on;

plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.q * 180 / pi, '-o', "DisplayName", "UAV f q");
plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.r * 180 / pi, '-o', "DisplayName", "UAV f r");

ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(3) = subplot(313);
plot(spHandle.Time / 1e6, spHandle.FlightMode, '-o', "DisplayName", "FlightMode", "Color", "blue");
ylabel("Mode");
hold on; grid on;
yyaxis right;
plot(spHandle.Time / 1e6, spHandle.PrioPsi, '-o', "DisplayName", "Prio Psi");
plot(spHandle.Time / 1e6, spHandle.PrioPsi_dot, '--o', "DisplayName", "Prio Psi_dot", "Color", "black");
plot(spHandle.Time / 1e6, spHandle.Prior, '-.*', "DisplayName", "Prio r", "Color", "yellow");
ylabel("Prio");
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')
legend("Interpreter", "none")
xlabel("Time [s]");

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);

linkaxes(ax,'x');
legend

%% Plot SP Rate vs Hoeming
figure
ax(1) = subplot(311);
plot(spHandle.Time / 1e6, spHandle.p * 180 / pi, '-o', "DisplayName", "SP p");
hold on; grid on;

plot(spHandle.Time / 1e6, spHandle.q * 180 / pi, '-o', "DisplayName", "SP q");
plot(spHandle.Time / 1e6, spHandle.r * 180 / pi, '-o', "DisplayName", "SP r");

title("Rate SP")
ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(2) = subplot(312);

plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.p * 180 / pi, '-o', "DisplayName", "UAV f p");
hold on; grid on;

plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.q * 180 / pi, '-o', "DisplayName", "UAV f q");
plot(frameKC.rateFilterredSample.data.Time, frameKC.rateFilterredSample.data.r * 180 / pi, '-o', "DisplayName", "UAV f r");

ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(3) = subplot(313);
plot(spHandle.Time / 1e6, spHandle.FlightMode, '-o', "DisplayName", "FlightMode", "Color", "blue");
ylabel("Mode");
hold on; grid on;
yyaxis right;
plot(spHandle.Time / 1e6, spHandle.PrioPsi, '-o', "DisplayName", "Prio Psi");
plot(spHandle.Time / 1e6, spHandle.PrioPsi_dot, '--o', "DisplayName", "Prio Psi_dot", "Color", "black");
plot(spHandle.Time / 1e6, spHandle.Prior, '-.*', "DisplayName", "Prio r", "Color", "yellow");
ylabel("Prio");
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')
legend("Interpreter", "none")
xlabel("Time [s]");

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);

linkaxes(ax,'x');
legend

% Raw rate vs SP
%% Plot SP Rate vs Hoeming
figure
ax(1) = subplot(311);
plot(spHandle.Time / 1e6, spHandle.p * 180 / pi, '-o', "DisplayName", "SP p");
hold on; grid on;

plot(spHandle.Time / 1e6, spHandle.q * 180 / pi, '-o', "DisplayName", "SP q");
plot(spHandle.Time / 1e6, spHandle.r * 180 / pi, '-o', "DisplayName", "SP r");

title("Rate SP")
ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(2) = subplot(312);

plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.p * 180 / pi, '-o', "DisplayName", "UAV p");
hold on; grid on;

plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.q * 180 / pi, '-o', "DisplayName", "UAV q");
plot(frameKC.rateSample.data.Time, frameKC.rateSample.data.r * 180 / pi, '-o', "DisplayName", "UAV r");

ylabel("Angle [deg]");
xlabel("Time [s]");
legend("Interpreter", "none")

ax(3) = subplot(313);
plot(spHandle.Time / 1e6, spHandle.FlightMode, '-o', "DisplayName", "FlightMode", "Color", "blue");
ylabel("Mode");
hold on; grid on;
yyaxis right;
plot(spHandle.Time / 1e6, spHandle.PrioPsi, '-o', "DisplayName", "Prio Psi");
plot(spHandle.Time / 1e6, spHandle.PrioPsi_dot, '--o', "DisplayName", "Prio Psi_dot", "Color", "black");
plot(spHandle.Time / 1e6, spHandle.Prior, '-.*', "DisplayName", "Prio r", "Color", "yellow");
ylabel("Prio");
set(groot, 'DefaultAxesTickLabelInterpreter', 'none')
legend("Interpreter", "none")
xlabel("Time [s]");

FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);

linkaxes(ax,'x');
legend


