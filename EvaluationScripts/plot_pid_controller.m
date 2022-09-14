function plot_pid_controller()
    global data 
    
    figure("Name", "PID Controller States");
    fNames = fieldnames(data.dataTable.PID_CONTROLLER);
    for i = 1:numel(fNames)
       figure("Name", fNames{i});
       ax(i) = axes();
       plotPID(ax(i), data.dataTable.PID_CONTROLLER.(fNames{i}), [-inf inf]);
       title(sprintf("%s", fNames{i}));
       xlabel("Time [s]");
       ylabel("Magnitude");
    end
    
    linkaxes(ax, 'x');
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
end


