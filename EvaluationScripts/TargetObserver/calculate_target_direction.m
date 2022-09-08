
%  This method computes the target vector in NED frame from the given
%  n sensor values. 
%  Input:
%       att_uav_deg:        [PhiVec, ThetaVec, PsiVec] in degree
%       att_gimbal_deg:     [PhiVec, ThetaVec, PsiVec] in degree
%       target_cam_sph_deg: [azimuthVec, elevationVec] in degree
%  Output:
%       Target in NED frame: [North, East, Down] of n samples
function [target_ned] = calculate_target_direction(att_uav_deg, att_gimbal_deg, target_cam_sph_deg)
    deg2rad = pi / 180;
    n = size(target_cam_sph_deg, 1);
    % Get the constant transformation methods as function handler
    func = trans_func(); 

    out = zeros(n, 3);
    for i = 1:n
        % Transform target vector - camera frame (spherical) to gimbal (xyz)
        [x,y,z] =  sph2cart(target_cam_sph_deg(i,1) * deg2rad, target_cam_sph_deg(i,2) * deg2rad, 1); 
        % Reverse down direction for NED
        norm_target_dir_gimbal_body = [x,y, -z]'; 
        % Transform target vector - gimbal frame to UAV body frame
        norm_target_dir_uav_body = func.body_to_ned(norm_target_dir_gimbal_body, att_gimbal_deg(i,1) * deg2rad, att_gimbal_deg(i,2) * deg2rad, att_gimbal_deg(i,3) * deg2rad);
        % Transform target in UAV body frame - NED frame
        out(i,:) = func.body_to_ned(norm_target_dir_uav_body, att_uav_deg(i,1) * deg2rad, att_uav_deg(i,2) * deg2rad, att_uav_deg(i,3) * deg2rad);
    end
    target_ned = out;
end

