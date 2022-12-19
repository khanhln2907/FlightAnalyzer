function [out] = plot_camera_sample(target_info, ax)

    if(exist('ax','var'))

    else
        figure
        ax = axes();
    end
    
    out.cam_elv = plot(ax, target_info.TimePacket/ 1e6, target_info.Elevation, "DisplayName", "Camera Pitch");
    hold on;     grid on;
    out.cam_azi = plot(ax, target_info.TimePacket / 1e6, target_info.Azimuth,  "DisplayName", "Camera Yaw");
    legend;
    xlabel("Time [s]")
    ylabel("Angle [Deg]")
end


