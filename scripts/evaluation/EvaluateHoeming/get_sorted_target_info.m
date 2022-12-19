function [out] = get_sorted_target_info(targetInfo)
    tTeensy = targetInfo.TimePacket /1e6;
    tEnc = (targetInfo.TimePacket - targetInfo.TimeEncoder) / 1e6;
    tCam = (targetInfo.TimePacket - targetInfo.TimeCamera) / 1e6;
    
    out.tTeensy = tTeensy(2:end) * 1e6;
    out.tEnc = tEnc(2:end) * 1e6;
    out.tCam = tCam(2:end) * 1e6;
    out.dtTeensy = diff(targetInfo.TimePacket);
 
    [~, iUniqueEnc, ~] = unique(targetInfo{:, ["Phi_Enc", "Theta_Enc", "Psi_Enc"]}, "row");
    [~, iUniqueCam, ~] = unique(targetInfo{:, ["Elevation", "Azimuth"]}, "row");

    out.rxTEnc = targetInfo.TimeEncoder(2:end);
    out.EncPhi = targetInfo.Phi_Enc(2:end);
    out.EncTheta = targetInfo.Theta_Enc(2:end);
    out.EncPsi = targetInfo.Psi_Enc(2:end);

    out.uniqueEncFlag = zeros(size(tEnc,1) -1,1);
    out.uniqueEncFlag(iUniqueEnc) = 1;
    out.uniqueEncFlag = circshift(out.uniqueEncFlag , -1);
    
    out.rxTCam = targetInfo.TimeCamera(2:end);
    out.Elevation = targetInfo.Elevation(2:end);
    out.Azimuth = targetInfo.Azimuth(2:end);
    
    out.uniqueCamFlag = zeros(size(tCam,1) - 1,1);
    out.uniqueCamFlag(iUniqueCam) = 1;
    out.uniqueCamFlag = circshift(out.uniqueCamFlag, -1);
    
    out.tTeensy(diff(out.tTeensy) < 0) = nan;
    
    out = struct2table(out);

end

