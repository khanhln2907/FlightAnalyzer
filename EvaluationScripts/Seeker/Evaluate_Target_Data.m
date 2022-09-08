if(exist('dataTable','var'))
    data = dataTable;
else
   dataHandle = load('FlightLogs\2022-01-18\K2\Parsed_LOG00000.mat'); 
   data = dataHandle.dataTable;    
end

%close all;
%% Constant
deg2rad = pi / 180;

uav_att = data.ATTITUDE;
uav_att.Phi = uav_att.Phi; 
uav_att.Theta = uav_att.Theta; 
uav_att.Psi = uav_att.Psi; 

% Preprocess the imu data to obtain the attitudes with timestamp matched
% the camera
target_info = data.TARGET_INFO;

%[c,lags] = xcorr(uav_att.Theta, target_info.Theta_Enc);
%stem(lags,c)

predicted_delay_s = 0; %0.040; %; 0.055; %0.055;
target_info.TimePacket = target_info.TimePacket - predicted_delay_s * 1e6;

% Consider the time the mission was started
uav_calc.Time = target_info.TimeEncoder;
uav_calc.Phi = interp1(uav_att.Time, uav_att.Phi, uav_calc.Time, 'linear');
uav_calc.Theta = interp1(uav_att.Time, uav_att.Theta, uav_calc.Time, 'linear');
uav_calc.Psi = interp1(uav_att.Time, uav_att.Psi, uav_calc.Time, 'linear');

%% Plot the interpolation
if(1)
    figure
    subplot(311)
    plot(uav_att.Time / 1e6, uav_att.Phi, 'o');
    hold on; grid on;
    plot(uav_calc.Time / 1e6, uav_calc.Phi, '*');
    ylabel("Phi [deg]")
    subplot(312)
    plot(uav_att.Time / 1e6, uav_att.Theta, 'o');
    hold on; grid on;
    plot(uav_calc.Time / 1e6, uav_calc.Theta, '*');
    ylabel("Theta [deg]")
    subplot(313)
    plot(uav_att.Time / 1e6, uav_att.Psi, 'o');
    hold on; grid on;
    plot(uav_calc.Time / 1e6, uav_calc.Psi, '*');
    ylabel("Psi [deg]")
    sgtitle('UAV Attitudes [deg]') 
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end


%% BEGIN HERE
att_uav_deg = [uav_calc.Phi, uav_calc.Theta, uav_calc.Psi];
att_gimbal_deg = [target_info.Phi_Enc, target_info.Theta_Enc, target_info.Psi_Enc];
target_cam_sph_deg = [target_info.Azimuth, target_info.Elevation];
code_calc_target_ned = calculate_target_direction(att_uav_deg, att_gimbal_deg, target_cam_sph_deg);

% Visualize calculated Target in NED Frame and Velocity
figure
vel = 15;
plot(target_info.TimePacket / 1e6, code_calc_target_ned(:,1) * vel, 'o', "DisplayName", "Calc North");
hold on; grid on;
plot(data.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, data.FCON_SET_HOMEINGDIRECTION_SIG.VecX * vel, '*', "DisplayName", "Logged North", "Color", [1 0 0])

plot(target_info.TimePacket / 1e6, code_calc_target_ned(:,2) * vel, 'o', "DisplayName", "Calc East");
plot(data.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, data.FCON_SET_HOMEINGDIRECTION_SIG.VecY * vel, '*', "DisplayName", "Logged East", "Color", [1 0 0])

plot(target_info.TimePacket / 1e6, code_calc_target_ned(:,3) * vel, 'o', "DisplayName", "Calc Down");
plot(data.FCON_SET_HOMEINGDIRECTION_SIG.Time / 1e6, data.FCON_SET_HOMEINGDIRECTION_SIG.VecZ * vel, '*', "DisplayName", "Logged Down", "Color", [1 0 0])

title("Reconstructed target vector NED with vel = 15 m/s")
legend
xlabel("Time [s]")
title("Reconstructed Calculated Target in NED Frame with Setpoint")
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
%% END HERE


%% Visualize 3d
if(0)
    figure
    ax = axes();
    %Plot the origin and the coordinates
    ORIGIN_P = zeros(3);

    REF_NED = [1, 0, 0;
               0,  1, 0;
               0,  0, 1];

    quiver3(ax, ORIGIN_P(:,1),ORIGIN_P(:,2),ORIGIN_P(:,3),REF_NED(:,1), REF_NED(:,2), REF_NED(:,3), "DisplayName", "NED", "Color", 'r');
    hold on; axis equal;
    xlabel("x");
    ylabel("y");
    zlabel("z");
    xlim([-1,1]);
    ylim([-1,1]);
    zlim([-1,1]);
    % animation
    %visualize_target_ned(ax, calc_target_data_ned);
    visualize_target_ned(ax, wrong_calc_target_data_ned);
end



%% Visualization
% Attitude 
figure
plot( target_info.TimePacket / 1e6, code_calc_target_ned(:,2), 'o', "DisplayName", " Target Body Elevation");
hold on; grid on;
plot( target_info.TimePacket / 1e6, target_info.Elevation, 'o', "DisplayName", "Camera Pitch")
plot( target_info.TimePacket / 1e6, target_info.Theta_Enc, '*', "DisplayName", "Encoder Pitch")
plot( target_info.TimePacket / 1e6, - uav_calc.Theta, 'x', "DisplayName", "Negative UAV Pitch")
xlabel("Time [s]");
ylabel("Angle [deg]");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
title("Target in Body Frame and Attitude")
legend;

%% Velocity 3 axis
figure
plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelNorth, "DisplayName", "Vel North")
hold on; grid on;
plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelEast,  "DisplayName", "Vel East")
plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelDown,  "DisplayName", "Vel Down")
vel = sqrt(data.VELOCITY_NED.VelNorth.^2 + data.VELOCITY_NED.VelEast.^2 + data.VELOCITY_NED.VelDown.^2);
plot(data.VELOCITY_NED.Time / 1e6, vel,  "DisplayName", "Vel total")
xlabel("Time [s]")
ylabel("Velocity [m/s]")
title("Measured Velocity NED")
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
legend

%% Velocity setpoint
%spVel = data.FCON_LOG_SP.VelNorth, data.FCON_LOG_SP.VelEast, data.FCON_LOG_SP.VelDown;
% figure
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelNorth, 'o', "DisplayName", "North")
% hold on; grid on;
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelEast, 'o', "DisplayName", "East")
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelDown, 'o', "DisplayName", "Down")
% xlabel("Time [s]")
% ylabel("Velocity [m/s]")
% title("Velcocity Setpoint in NED Frame")
% legend;
% FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

%% Calculated Target in NED Frame and Velocity
% figure
% vel = 15;
% lineNorth = plot(target_info.TimePacket / 1e6, calc_target_data_ned(:,1) * vel, 'o', "DisplayName", "Target North");
% hold on; grid on;
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelNorth, '.', "DisplayName", "Logged SP North", "Color", lineNorth.Color)
% 
% lineEast = plot(target_info.TimePacket / 1e6, calc_target_data_ned(:,2) * vel, 'o', "DisplayName", "Target East");
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelEast, '.', "DisplayName", "SP East", "Color", lineEast.Color)
% 
% lineDown = plot(target_info.TimePacket / 1e6, calc_target_data_ned(:,3) * vel, 'o', "DisplayName", "Target Down");
% plot(data.FCON_LOG_SP.Time / 1e6, data.FCON_LOG_SP.VelDown, '.', "DisplayName", "SP Down", "Color", lineDown.Color)
% 
% title("Calculated target vector NED with vel = 15 m/s versus the Logged SPs")
% legend
% xlabel("Time [s]")
% FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
% 

%% Helper functions



function visualize_target_2d(target_data)
    figure
    scatter(target_data(1,1), target_data(1,2), 'MarkerEdgeColor',[0 .5 .5]);
    hold on;
    xlim([-30, 30])
    ylim([-60, 60])
    for i = 1: size(target_data, 1)
        scatter(target_data(i,1), target_data(i,2), 'MarkerEdgeColor',[0 .5 .5]);
        pause(0.0005);
    end
end

function visualize_target_3d(ax, target_data) % taget_data = [psi, theta]
    x = @(psi, theta) cos(theta).*cos(psi);
    y = @(psi, theta) cos(theta).*sin(psi);
    z = @(psi) sin(psi);
    
    target_x = x(target_data(:,1), target_data(:,2));
    target_y = y(target_data(:,1), target_data(:,2));
    target_z = z(target_data(:,2));
    
    h = quiver3(ax, 0,0,0, target_x(1), target_y(1), target_z(1), 'MarkerEdgeColor',[0 .5 .5]);
    for i = 1: size(target_data, 1)
        h.UData = target_x(i);
        h.VData = target_y(i);
        h.WData = target_z(i);
        pause(0.0005);
    end
end

function visualize_target_ned(ax, target_data) % taget_data = [x, y, z]
    h = quiver3(ax, 0,0,0, target_data(1,1), target_data(1,2), target_data(1,3), 'MarkerEdgeColor',[0 .5 .5], "Color", 'b');
    for i = 1: size(target_data, 1)
        h.UData = target_data(i,1);
        h.VData = target_data(i,2);
        h.WData = target_data(i,3);
        pause(0.0005);
    end
end

