function [out] = plot_time_jittering(targetInfo)

    tTeensy = targetInfo.TimePacket /1e6;
    tEnc = (targetInfo.TimePacket - targetInfo.TimeEncoder) / 1e6;
    tCam = (targetInfo.TimePacket - targetInfo.TimeCamera) / 1e6;
    
    dtTeensy = diff(tTeensy) * 1e3;
    dtTeensy(dtTeensy > 10000) = nan; % Ignore different segments of mission
    dtEnc = diff(tEnc) * 1e3;
    dtCam = diff(tCam) * 1e3;
    dtEnc(dtEnc == 0) = nan;
    dtCam(dtCam == 0) = nan;
    
    
    figure
    plot(tTeensy(1:end-1), dtEnc, '-o');
    hold on; grid on; grid minor;
    plot(tTeensy(1:end-1), dtCam, '-o');
    plot(tTeensy(1:end-1), dtTeensy, '-o');
    legend(["Encoder", "Camera", "Teensy"]);
    xlabel("Time [s]");
    ylabel("dt [ms]");
    
    FormatFigure(gcf, 12, 12/8);
    yThres = max([abs(targetInfo.TimeEncoder); abs(targetInfo.TimeCamera)]);
    ylim([-yThres yThres]/1e3);
    
    out.tTeensy = tTeensy(2:end) * 1e6;
    out.tEnc = tEnc(2:end) * 1e6;
    out.tCam = tCam(2:end) * 1e6;
    out.dtTeensy = diff( targetInfo.TimePacket);
    %out.dtCam = diff((targetInfo.TimePacket - targetInfo.TimeCamera));
    %out.dtEnc = diff((targetInfo.TimePacket - targetInfo.TimeEncoder));
 
    [~, iUniqueEnc, ~] = unique(targetInfo{:, ["Phi_Enc", "Theta_Enc", "Psi_Enc"]}, "row");
    [~, iUniqueCam, ~] = unique(targetInfo{:, ["Elevation", "Azimuth"]}, "row");

    out.rxTEnc = targetInfo.TimeEncoder(2:end);
    out.EncPhi = targetInfo.Phi_Enc(2:end);
    out.EncTheta = targetInfo.Theta_Enc(2:end);
    out.EncPsi = targetInfo.Psi_Enc(2:end);

    out.uniqueEncFlag = zeros(size(dtEnc));
    out.uniqueEncFlag(iUniqueEnc) = 1;
    out.uniqueEncFlag = circshift(out.uniqueEncFlag , -1);
    
    out.rxTCam = targetInfo.TimeCamera(2:end);
    out.Elevation = targetInfo.Elevation(2:end);
    out.Azimuth = targetInfo.Azimuth(2:end);
    
    out.uniqueCamFlag = zeros(size(dtCam));
    out.uniqueCamFlag(iUniqueCam) = 1;
    out.uniqueCamFlag = circshift(out.uniqueCamFlag, -1);
    
    
    out = struct2table(out);
    
    %out(out.uniqueEncFlag ~= 1, :) = [];
    %out(out.uniqueCamFlag ~= 1, :) = [];

end

