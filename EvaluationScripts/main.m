% Load the data
global data

path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_09-Sep-2022.mat"');
data = get_data_0908(path);

% Get additional data


%% plotting
global tInterval
tInterval = [-inf inf];

close all;
%plot_flight_mode()
%plot_attitude()
%plot_pid_controller()
%analyze_cross_corr_pid(693, 695);
analyze_cross_corr_seeker(687, 696);

function analyze_cross_corr_pid(t_min_s, t_max_s)
    global data
    %global tInterval
    
    
    fRate = get_topic_sample_interval(data.rawDataTable.FILTERED_ATTITUDE_RATE, t_min_s, t_max_s);
    pPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.pPID, t_min_s, t_max_s);

    figure("Name", "p Out vs fRate p");
    [c,lags] = xcorr(fRate.p, pPID.outP, 50);
    stem(lags,c)
    
    %%
    pPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.pPID, t_min_s, t_max_s);
    %dPID = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.dPID, t_min_s, t_max_s);
    %pidTotal = get_topic_sample_interval(data.rawDataTable.PID_CONTROLLER.Total, t_min_s, t_max_s);
    figure("Name", "pOut, pidTotal");
    subplot(221);
    [c,lags] = xcorr(pPID.outP, pPID.Total, 20);
    stem(lags,c)
    title("p vs Total")
    
    subplot(222);
    [c,lags] = xcorr(pPID.outD, pPID.Total, 20);
    stem(lags,c)
    title("d vs Total")

    subplot(223);
    [c,lags] = xcorr(pPID.outP, pPID.outD, 20);
    stem(lags,c)
    title("p vs d")

    subplot(224);
    [c,lags] = xcorr(fRate.p, pPID.Total, 20);
    stem(lags,c)
    title("fRate vs PID")
end

function analyze_cross_corr_seeker(t_min_s, t_max_s)
    global data
    
    encSample = data.rawDataTable.TARGET_INFO(:, ["TimePacket", "Phi_Enc", "Theta_Enc", "Psi_Enc"]);
    encSample.Time = encSample.TimePacket;
    encSample.TimePacket = [];
    encSample.Phi = encSample.Phi_Enc;
    encSample.Theta = encSample.Theta_Enc;
    encSample.Psi = encSample.Psi_Enc;
    
    
    encAttData = get_topic_sample_interval(encSample, t_min_s, t_max_s);
    analyzedEncSample = AttitudeSample("Encoder_Seeker", encAttData, 120);    

    att = get_topic_sample_interval(data.rawDataTable.ATTITUDE, t_min_s, t_max_s);
    
    figure("Name", "Enc Att vs UAV Att");
    subplot(2,2,1)
    [c,lags] = xcorr(att.Phi, analyzedEncSample.data.Phi);
    stem(lags,c);
    legend(["Phi"]);

    subplot(2,2,2)
    plot(att.Time / 1e6, att.Phi, "-o", "DisplayName", "Phi UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, -analyzedEncSample.data.Phi, "-o", "DisplayName", "Phi ENC");
    legend;
    
    subplot(2,2,3)
    [c,lags] = xcorr(att.Theta, analyzedEncSample.data.Theta);
    stem(lags,c);
    legend(["Theta"]);

    subplot(2,2,4)
    plot(att.Time / 1e6, att.Theta, "-o", "DisplayName", "Theta UAV");
    hold on; grid on;
    plot(analyzedEncSample.data.Time, analyzedEncSample.data.Theta, "-o", "DisplayName", "Theta ENC");
    legend;

    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
end


function plot_attitude()
    global data 
    global tInterval
    
    axisHandle = data.attAnalyzer.plot_time_domain_multi_figure("TimeInterval", tInterval);
    
    for i = numel(axisHandle)
        data.flightAnalyzer.plot_flight_mode(axisHandle{i}, tInterval);
        FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
        legend;
    end
end


function plot_pid_controller()
    global data 
    global tInterval
    
    figure("Name", "PID Controller States");
    fNames = fieldnames(data.dataTable.PID_CONTROLLER);
    for i = 1:numel(fNames)
       %ax(i) = subplot(2, 3, mod(i,7));
       figure
       ax(i) = axes();
       plotPID(ax(i), data.dataTable.PID_CONTROLLER.(fNames{i}), tInterval);
       title(sprintf("%s", fNames{i}));
       FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
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
    ylabel("RC KS");

    xline(data.dataTable.FCON_PID_VALUES.Time/1e6, "LineWidth", 2, "DisplayName", "PID Profile");
    
    ax = gca;
    data.flightAnalyzer.plot_flight_mode(ax, tInterval);
    hold on;
    
    title("Flight and Controller Mode");
    FormatFigure(gcf, 12, 12/8);
end


