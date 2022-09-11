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
plot_pid_controller()



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


