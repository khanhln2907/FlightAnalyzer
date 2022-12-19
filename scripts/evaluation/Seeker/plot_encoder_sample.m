function [out] = plot_encoder_sample(target_info, ax)
    if(exist('ax','var'))

    else
        figure
        
        ax = axes();
    end
    
    out.enc_theta = plot(ax, target_info.TimePacket/ 1e6, target_info.Theta_Enc, "DisplayName", "Encoder Pitch");
    hold on;     grid on;
    out.enc_psi = plot(ax, target_info.TimePacket / 1e6, target_info.Psi_Enc, "DisplayName", "Encoder Yaw");
    legend;
    xlabel("Time [s]")
    ylabel("Angle [Deg]")
end

