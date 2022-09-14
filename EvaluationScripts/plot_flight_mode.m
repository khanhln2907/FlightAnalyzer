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