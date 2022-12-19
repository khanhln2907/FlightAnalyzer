function plot_camera_time_step(target_info)
    figure   
    subplot(2,1,1)
    dt_s = diff(target_info.TimeCamera) / 1e6;
    dt_s = dt_s(dt_s > 0);
    histogram(dt_s(dt_s < 0.05))
    xlabel("Time [s]");
    ylabel("Amount")
    title("Distribution of camera's time step");
    
    fprintf("Maximum time step of Camera: %.4f s| Avarage time step of Camera: %.4f s\n", max(dt_s(dt_s > 0)), mean(dt_s(dt_s > 0)));
    
    subplot(2,1,2)
    plot(target_info.TimePacket(1:end-1) / 1e6, diff(target_info.TimeCamera) / 1e3, '-o', "DisplayName", "\Delta t Camera");
    legend;
    %title("Time between each samples from the encoders");
    xlabel("Time [s]");
    ylabel("\Delta t [ms]");
    
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);   
end
