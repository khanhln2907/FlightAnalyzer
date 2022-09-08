%  This method computes the target vector in NED frame from the given
%  n sensor samples. The samples might have mismatched timestamp.
%  Input:
%       att_uav_deg:        [timestamp, PhiVec, ThetaVec, PsiVec] in degree
%       att_gimbal_deg:     [timestamp, PhiVec, ThetaVec, PsiVec] in degree
%       target_cam_sph_deg: [timestamp, azimuthVec, elevationVec] in degree
%  Output:
%       Target in NED frame: [North, East, Down] of n samples
function [sample_target_ned, matched_timestamp] = async_calculate_target_direction(sample_att_uav_deg, sample_att_gimbal_deg, sample_target_cam_sph_deg)
    deg2rad = pi/180;
    
    %% Perform pre-interpolation if needed
    % ...
    % ...
    
    
    %% Calculate the target under consideration of timestamps
    time_enc = sample_att_gimbal_deg(:,1);
    time_cam = sample_target_cam_sph_deg(:,1);
    n_samples = min(size(time_enc,1), size(time_cam,1)); % Get the minimum amount of samples
    
    % Going through set of samples to compute the target vector
    sample_target_ned = zeros(n_samples, 4);
    matched_timestamp = zeros(n_samples, 3); % This is be used to evaluate the matching
    
    for i = 1:n_samples
        % Get the available (real-time / causal) sample
        enc_avail = sample_att_gimbal_deg(1:i, :);
        cam_avail = sample_target_cam_sph_deg(1:i, :);
        
        % The latest available target info during the operation 
        t_enc = enc_avail(end,1);
        t_cam = cam_avail(end,1);
        
        % Get the time used to compute the target (t_ref for all three measurements from IMU, gimbal, encoder)
        t_oldest = t_enc;% ;min(t_cam, t_enc);

        % Find the macthed values in the available buffer 

        % imu - assume data is always available
        dt_diff_imu = t_oldest - sample_att_uav_deg(:,1);
        [~, id_imu] = min(abs(dt_diff_imu));

        % encoder
        dt_diff_enc = t_oldest - enc_avail(:,1);
        [~, id_enc] = min(abs(dt_diff_enc));

        % camera
        dt_diff_cam = t_oldest - cam_avail(:,1);
        [~, id_cam] = min(abs(dt_diff_cam));

        % Compute the target in NED frame
        % The timestamp
        sample_target_ned(i, 1) = t_oldest;
        % The reconstructed value
        sample_target_ned(i, 2:4) = calculate_target_direction(sample_att_uav_deg(id_imu, 2:4), enc_avail(id_enc, 2:4), cam_avail(id_cam, 2:3));
        matched_timestamp(i,:) =  [sample_att_uav_deg(id_imu, 1), enc_avail(id_enc, 1), cam_avail(id_cam, 1)];
    end
    
    %% Perform post-interpolation if needed
    % ...
    % ...
    
    
end


% function data_interpolation()
%     pre_intrpl_flag = 0;
%         compensated_flag = 0;
% 
%         %% Perform pre-interpolation if needed
%         pre_intrpl_flag = 0;
%         compensated_flag = 0;
% 
%         if (pre_intrpl_flag)        
%             %interpl_att_uav_time =  interp1(sample_att_uav_deg(:,1),  sample_att_uav_deg(:,1), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_att_uav_phi = interp1(sample_att_uav_deg(:,1),  sample_att_uav_deg(:,2), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_att_uav_theta = interp1(sample_att_uav_deg(:,1),  sample_att_uav_deg(:,3), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_att_uav_psi = interp1(sample_att_uav_deg(:,1),  sample_att_uav_deg(:,4), sample_target_cam_sph_deg(:,1), 'linear');
%             sample_att_uav_deg = [sample_target_cam_sph_deg(:,1), interpl_att_uav_phi, interpl_att_uav_theta, interpl_att_uav_psi];
% 
%             interpl_rate_uav_p = interp1(sample_rate_uav_deg(:,1),  sample_rate_uav_deg(:,2), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_rate_uav_q = interp1(sample_rate_uav_deg(:,1),  sample_rate_uav_deg(:,3), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_rate_uav_r = interp1(sample_rate_uav_deg(:,1),  sample_rate_uav_deg(:,4), sample_target_cam_sph_deg(:,1), 'linear');
%             sample_rate_uav_deg = [sample_target_cam_sph_deg(:,1), interpl_rate_uav_p, interpl_rate_uav_q, interpl_rate_uav_r];
% 
%             sample_att_gimbal_deg = unique(sample_att_gimbal_deg,'rows');
%             interpl_att_gimbal_phi = interp1(sample_att_gimbal_deg(:,1),  sample_att_gimbal_deg(:,2), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_att_gimbal_theta = interp1(sample_att_gimbal_deg(:,1),  sample_att_gimbal_deg(:,3), sample_target_cam_sph_deg(:,1), 'linear');
%             interpl_att_gimbal_psi = interp1(sample_att_gimbal_deg(:,1),  sample_att_gimbal_deg(:,4), sample_target_cam_sph_deg(:,1), 'linear');
%             sample_att_gimbal_deg = [sample_target_cam_sph_deg(:,1), interpl_att_gimbal_phi, interpl_att_gimbal_theta, interpl_att_gimbal_psi];
%         end
% 
% end



