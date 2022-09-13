% Load the data
global data

%path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_12-Sep-2022 06_47_36.mat"');
%path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00005\MATLAB', "flight_data_parsed_12-Sep-2022 08_52_25.mat"');
%path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00003\MATLAB', "flight_data_parsed_12-Sep-2022 08_50_08.mat"');
path = fullfile(pwd,'Local\2022-09-13\KC2\Processed_LOG00002\MATLAB', "flight_data_parsed_13-Sep-2022 16_25_57.mat"');
data = get_data_0908(path);

% Get additional data

figure
set(0,'DefaultFigureWindowStyle','docked')

%% plotting
global tInterval
tInterval = [-inf inf];

%close all;
plot_flight_mode()
plot_velocity()
plot_attitude()

%%
%plot_pid_controller()
%analyze_cross_corr_pid(693, 695);
%%
%analyze_cross_corr_seeker(683, 703);

try
    analyze_cross_corr_seeker(200, 230);
catch
    
end

%%
function analyze_cross_corr_pid(t_min_s, t_max_s)
    global data
    %global tInterval
    
    
    fRate = get_topic_sample_interval(data.rawDataTable.FILTERED_ATTITUDE_RATE, t_min_s, t_max_s);
    pPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.pPID, t_min_s, t_max_s);

    figure("Name", "p Out vs fRate p");
    [c,lags] = get_cross_orr(fRate.p, pPID.outP);
    stem(lags,c)
    
    %%
    pPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.pPID, t_min_s, t_max_s);
    %dPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.dPID, t_min_s, t_max_s);
    %pidTotal = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.Total, t_min_s, t_max_s);
    figure("Name", "pOut, pidTotal");
    subplot(221);
    [c,lags] = get_cross_orr(pPID.outP, pPID.Total);
    stem(lags,c)
    title("p vs Total")
    
    subplot(222);
    [c,lags] = get_cross_orr(pPID.outD, pPID.Total);
    stem(lags,c)
    title("d vs Total")

    subplot(223);
    [c,lags] = get_cross_orr(pPID.outP, pPID.outD);
    stem(lags,c)
    title("p vs d")

    subplot(224);
    [c,lags] = get_cross_orr(fRate.p, pPID.Total);
    stem(lags,c)
    title("fRate vs PID")
end

function analyze_cross_corr_seeker(t_min_s, t_max_s)
    global data
    
    encSample = data.SEEKER.TargetInfo(:, ["tEnc", "EncPhi", "EncTheta", "EncPsi", "tTeensy"]);
    encSample.Time = encSample.tEnc;
    encSample.Phi = encSample.EncPhi;
    encSample.Theta = encSample.EncTheta;
    encSample.Psi = encSample.EncPsi;
    %encSample = get_topic_sample_interval(encSample, t_min_s, t_max_s);
    
    tRef = encSample.Time;
    intplUAVData = get_intpl_table(data.dataTable.ATTITUDE, tRef, "linear");
    %intplUAVData = get_intpl_table(data.dataTable.ATTITUDE, tRef, "linear");
    intplUAVData = get_topic_sample_interval(intplUAVData, t_min_s, t_max_s);
    uavAtt = get_topic_sample_interval(data.dataTable.ATTITUDE, t_min_s, t_max_s);

    encAttData = get_topic_sample_interval(encSample, t_min_s, t_max_s);    
    analyzedEncSample = AttitudeSample("Encoder_Seeker", encAttData, 120);    

    
    figure("Name", "Org vs Shifted UAV Att")
    %plot(intplUAVData.Time / 1e6, intplUAVData.Phi, "-o", "DisplayName", "UAV Intpl Phi");
    %plot(uavAtt.Time / 1e6, uavAtt.Phi, "-o", "DisplayName", "UAV Org Phi");
    plot(encSample.tTeensy / 1e6, encSample.Theta, "-o", "DisplayName", "Enc Theta Raw Ts");
   
    hold on;
    %plot(uavAtt.Time / 1e6, uavAtt.Theta, "-o", "DisplayName", "UAV Org Theta");
    %plot(intplUAVData.Time / 1e6, intplUAVData.Theta, "-o", "DisplayName", "UAV Intpl Theta");
    plot(encAttData.Time / 1e6, encAttData.Theta, "-o", "DisplayName", "Enc Theta Matched Ts");
    
    plot(encSample.tTeensy / 1e6, encSample.Phi, "-o", "DisplayName", "Enc Phi Raw Ts");
    plot(encAttData.Time / 1e6, encAttData.Phi, "-o", "DisplayName", "Enc Phi Matched Ts");
    legend
    xlabel("Time [s]");
    xlim([t_min_s, t_max_s]);

    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
    
    
    figure("Name", "Cross Correlation UAV and Seeker Analysis");    
    % Phi
    attPhiAC = intplUAVData.Phi;
    encPhiAC = analyzedEncSample.data.Phi; 
    
    
    subplot(2, 3,1)
    [c,lags] = get_cross_orr(attPhiAC, encPhiAC);
    [M,I] = max(abs(c));
    maxLagPhi = lags(I);
    fprintf("Seeker Evaluation. Est. lag Encoder Phi: %d [Samples]. dt XCorr UAV: %f [ms] \n", maxLagPhi, mean(diff(intplUAVData.Time)) / 1e3);
    
    stem(lags,c);
    legend(["Phi"]);

    subplot(2,3,2)
    plot(intplUAVData.Time / 1e6, attPhiAC, "-o", "DisplayName", "Phi UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, encPhiAC, "-o", "DisplayName", "Phi ENC");
    legend;
    
    attPhiAC = intplUAVData.Phi -mean(intplUAVData.Phi);
    encPhiAC = -(analyzedEncSample.data.Phi - mean(analyzedEncSample.data.Phi));
    subplot(2,3,3)
    plot(intplUAVData.Time / 1e6, attPhiAC, "-o", "DisplayName", "AC Phi UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, encPhiAC, "-o", "DisplayName", "AC Phi ENC Flip");
    legend;
    
    
    % Theta
    attThetaAC = intplUAVData.Theta;
    encThetaAC = analyzedEncSample.data.Theta;
    
    
    subplot(2,3,4)
    [c,lags] = get_cross_orr(attThetaAC, encThetaAC);
    stem(lags,abs(c));
    legend(["Theta"]);
    [M,I] = max(abs(c));
    maxLagTheta = lags(I);
    fprintf("Seeker Evaluation. Est. lag Encoder Theta: %d [Samples]. dt XCorr UAV: %f [ms] \n", maxLagTheta, mean(diff(intplUAVData.Time)) / 1e3);

    subplot(2,3,5)
    plot(intplUAVData.Time / 1e6, attThetaAC, "-o", "DisplayName", "Theta UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, encThetaAC, "-o", "DisplayName", "Theta ENC");
    legend;

    attThetaAC = intplUAVData.Theta -mean(intplUAVData.Theta);
    encThetaAC = -(analyzedEncSample.data.Theta - mean(analyzedEncSample.data.Theta));    
    subplot(2,3,6)
    plot(intplUAVData.Time / 1e6, attThetaAC, "-o", "DisplayName", "AC Theta UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, encThetaAC, "-o", "DisplayName", "AC Theta ENC Flip");
    legend;
    
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
end

function [cc,lag] = get_cross_orr(x,y)
    [cc,lag] = fastercorr(x,y);
    %[lag,ck,cc,td] = xcorrTD(x,y);
end


function plot_attitude()
    global data 
    global tInterval
    
    axisHandle = data.attAnalyzer.plot_time_domain_multi_figure("TimeInterval", tInterval);
    
%     for i = numel(axisHandle)
%         data.flightAnalyzer.plot_flight_mode(axisHandle{i}, tInterval);
%         FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
%         legend;
%     end
end

function plot_velocity()
    global data 
    global tInterval
    
    axisHandle = data.velAnalyzer.plot_time_domain_multi_figure("TimeInterval", tInterval);   
end


function plot_pid_controller()
    global data 
    global tInterval
    
    figure("Name", "PID Controller States");
    fNames = fieldnames(data.dataTable.PID_CONTROLLER);
    for i = 1:numel(fNames)
       %ax(i) = subplot(2, 3, mod(i,7));
       figure("Name", fNames{i});
       ax(i) = axes();
       plotPID(ax(i), data.dataTable.PID_CONTROLLER.(fNames{i}), tInterval);
       title(sprintf("%s", fNames{i}));
       FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
       xlabel("Time [s]");
       ylabel("Magnitude");
    end
    
    linkaxes(ax, 'x');
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
    legend("Interpreter", "None");  
end

function plotPID(ax, pidData, tInterval)
    pidData = get_topic_sample_interval(pidData, tInterval(1), tInterval(2));

    plot(ax, pidData.Time / 1e6, pidData.Integral, "-o", "DisplayName", "Integrator");
    hold on; grid on;
    plot(ax, pidData.Time / 1e6, pidData.Total, "-o", "DisplayName", "Total");
    plot(ax, pidData.Time / 1e6, pidData.outP, "-o", "DisplayName", "P");
    plot(ax, pidData.Time / 1e6, pidData.outI, "-o", "DisplayName", "I");
    plot(ax, pidData.Time / 1e6, pidData.outD, "-o", "DisplayName", "D");
    
%     yyaxis right;
%     dt = plot(ax, pidData.Time / 1e6, pidData.dt_s*1e3, "-o", "DisplayName", "dt_ms");    
%     dt.Color(4) = 0.1;
end



function plot_flight_mode()
    global data
    global tInterval
    
    h = figure('Name', 'Flight and Controller Mode');
    plot(data.dataTable.RC_KILLSWITCH.Time / 1e6,data.dataTable.RC_KILLSWITCH.KSState, "-o", "DisplayName", "RC KillSwitch");
    hold on;
    plot(data.dataTable.RC_MODE.Time / 1e6,data.dataTable.RC_MODE.ControlMode, "-o", "DisplayName", "RC Mode");
    %ylabel("RC KS");
    %legend();

    
    
    for i = 1: numel(data.dataTable.FCON_PID_VALUES.Time)
        xline(data.dataTable.FCON_PID_VALUES.Time(i)/1e6, "LineWidth", 2);
    end
    
    ax = gca;
    data.flightAnalyzer.plot_flight_mode(ax, tInterval);
    hold on;
    
    title("Flight and Controller Mode");
    FormatFigure(gcf, 12, 12/8);
end


