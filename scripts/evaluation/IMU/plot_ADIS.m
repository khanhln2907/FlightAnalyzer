close all

load('F:\AMDC_Workspace\FlightComputer_Analyzer\FlightLogs\2022-04-13\K4\Parsed_LOG00000.mat')
data = get_sync_time(dataTable);
data = allign_ADIS(data);

accelerationDataStr = ["ACCELERATION", "ACCELERATION_ADIS_B", "FILTERED_ATTITUDE_RATE", "ATTITUDE_RATE", "ATTITUDE_RATE_ADIS"];

t_min = 150; 
t_max = 350;

for i = 1:numel(accelerationDataStr)
     topicSample = data.(accelerationDataStr(i));
     dataADIS.(accelerationDataStr(i)) = get_topic_sample_interval(topicSample, t_min, t_max);
end

%% Perform mapping the data before processing
filePath = erase(dataTable.evaluation.FilePath, ".mat");
saveFolder = sprintf("%s_Figures", saveFolder);
mkdir(saveFolder);
dataADIS = allign_ADIS(dataADIS);


%% Plot and save rate info
rate = {"p", "q", "r"};
for i = 1:numel(rate)
    figure_name = sprintf("AttitudeRate_%s", rate{i});
    fig = figure('Name', figure_name, 'Position', get(0, 'Screensize'));
    plot(dataADIS.ATTITUDE_RATE_ADIS.Time / 1e6, dataADIS.ATTITUDE_RATE_ADIS.(rate{i}), '-o')
    hold on; grid on; grid minor;
    plot(dataADIS.ATTITUDE_RATE.Time / 1e6, dataADIS.ATTITUDE_RATE.(rate{i}), '-o')
    plot(dataADIS.FILTERED_ATTITUDE_RATE.Time / 1e6, dataADIS.FILTERED_ATTITUDE_RATE.(rate{i}), '-o')
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    xlabel("Time [s]");
    ylabel(sprintf("%s [rad/s]", (rate{i})));
    legend(["ADIS", "VN200", "Filtered VN200"]);
    fig.WindowState = 'maximized';    
    title("Attitude Rate")
    %exportgraphics(gcf, fullfile(fft_save_folder, sprintf("FFT_Hanning_Rec_PWM%d.png", selected_pwm)), 'Resolution', 300);
    saveas(gcf, fullfile(saveFolder, sprintf("%s.fig", figure_name)));
    saveas(gcf, fullfile(saveFolder, sprintf("%s.png", figure_name)));
end

%% Plot and save acceleration info
acc = {"Ax", "Ay", "Az"};
yName = {"a_x","a_y", "a_z"};
for i = 1:numel(acc)
    figure_name = sprintf("Acceleration_%s", acc{i});
    fig = figure('Name', figure_name, 'Position', get(0, 'Screensize'));
    plot(dataADIS.ACCELERATION_ADIS_B.Time / 1e6, dataADIS.ACCELERATION_ADIS_B.(acc{i}), '-o');
    hold on; grid on; grid minor;
    plot(dataADIS.ACCELERATION.Time / 1e6, dataADIS.ACCELERATION.(acc{i}), '-o')
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    xlabel("Time [s]");
    ylabel(sprintf("%s [m/s^2]", lower(yName{i})));
    legend(["ADIS", "VN200"]);
    title("Acceleration")
    fig.WindowState = 'maximized';    
    %exportgraphics(gcf, fullfile(fft_save_folder, sprintf("FFT_Hanning_Rec_PWM%d.png", selected_pwm)), 'Resolution', 300);
    saveas(gcf, fullfile(saveFolder, sprintf("%s.fig", figure_name)));
    saveas(gcf, fullfile(saveFolder, sprintf("%s.png", figure_name)));
end


