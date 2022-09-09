% Load the data
global data

path = fullfile(pwd,'Local\2022-09-08\KC2\Processed_LOG00004\MATLAB', "flight_data_parsed_09-Sep-2022.mat"');
data = get_data_0908(path);

% Get additional data


%% plotting
global tInterval
tInterval = [680 720];


plot_flight_mode()
plot_attitude()




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

end



function plot_flight_mode()
    global data
    global tInterval
    
    h = figure('Name', 'Flight and Controller Mode');
    plot(data.dataTable.RC_KILLSWITCH.Time / 1e6,data.dataTable.RC_KILLSWITCH.KSState, "-o", "DisplayName", "RC KillSwitch");
    hold on;
    plot(data.dataTable.RC_MODE.Time / 1e6,data.dataTable.RC_MODE.ControlMode, "-o", "DisplayName", "RC Mode");
    ylabel("RC KS");

    ax = gca;
    data.flightAnalyzer.plot_flight_mode(ax, tInterval);
    title("Flight and Controller Mode");
    FormatFigure(gcf, 12, 12/8);
end


