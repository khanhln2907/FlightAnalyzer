function [out] = plotTransit3D(dataTrs, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


out.Figure = figure('name', 'Transit 3D');
out.ax = axes();

% Plot one marker per second
if nargin < 2
dt = 1.;
end

timeDivider = 1e6;

Origin_X = dataTrs.POSITION.UTMCoord_x(1);
Origin_Y = dataTrs.POSITION.UTMCoord_y(2);

out.X_Ref = Origin_X;
out.Y_Ref = Origin_Y;

tMin = min(dataTrs.POSITION.Time) / timeDivider;
tMax = max(dataTrs.POSITION.Time)/ timeDivider;
duration = tMax - tMin;
t_plot = tMin:dt:tMax;

color = hot(numel(t_plot));
for n = 1:numel(t_plot)
  t_norm(n) = (t_plot(n) - min(t_plot)) / (max(t_plot) - min(t_plot));
end

% Plot actual trajectory.
UTM_X = interp1(dataTrs.POSITION.Time/ timeDivider, dataTrs.POSITION.UTMCoord_x, t_plot) - Origin_X;
UTM_Y = interp1(dataTrs.POSITION.Time/ timeDivider, dataTrs.POSITION.UTMCoord_y, t_plot) - Origin_Y;

% Filter out duplicate AGL data, which can occur when lidar is unreliable.
AGLData = dataTrs.AGL(dataTrs.AGL.Time(2:end) - dataTrs.AGL.Time(1:end-1) > 0,:);

AGL_Lidar = interp1(AGLData.Time/ timeDivider, AGLData.Value, t_plot);

%out.LineTrack = stem3(LatGPS, LongGPS, AGL_Lidar, 'filled', 'DisplayName', 'Track');
out.LineTrack = scatter3(UTM_X, UTM_Y, AGL_Lidar, 50, t_plot, 'filled', 'DisplayName', 'Track');
hold on;
out.LineTrackStem = stem3(UTM_X, UTM_Y, AGL_Lidar, 'Marker', 'none', 'DisplayName', 'Track', 'Color', [0.8 0.8 0.8 0.1]);
HideFromLegend(out.LineTrackStem);

hold on;

%% Plot Position setpoints
out = plotPositionSetpoints(dataTrs, out);
autoScaleFactor = 0.5;

%% add target directions
TargetDir = dataTrs.TARGET_DIRECTION;
[~, ia, ~] = unique(TargetDir.Time);
TargetDir = TargetDir(ia, :);
Dir_UTM = interp1(TargetDir.Time/1e6, ...
    [TargetDir.VelEast, TargetDir.VelNorth, -1*TargetDir.VelDown], ...
    t_plot,"linear","extrap");
out.TargetDir = quiver3(UTM_X, UTM_Y, AGL_Lidar, Dir_UTM(:,1)', Dir_UTM(:,2)', Dir_UTM(:,3)', "DisplayName", "Target", "AutoScaleFactor",autoScaleFactor);

%% Add Velocity-setpoint values
UAVVelSP = dataTrs.FCON_LOG_SP(:, {'Time', 'VelNorth', 'VelEast', 'VelDown', 'MaxV'});
UAVVelSP_UTM = interp1(UAVVelSP.Time/1e6, [UAVVelSP.VelEast, UAVVelSP.VelNorth, -1*UAVVelSP.VelDown], t_plot);
out.UAVVelocitySetpointQuiver = quiver3(UTM_X, UTM_Y, AGL_Lidar, UAVVelSP_UTM(:,1)', UAVVelSP_UTM(:,2)', UAVVelSP_UTM(:,3)','filled', "DisplayName", "VelSP", "AutoScaleFactor",autoScaleFactor);

%% Add actual velocity
UAVVel = dataTrs.VELOCITY_NED;
UAVVel_UTM = interp1(UAVVel.Time/1e6, [UAVVel.VelEast, UAVVel.VelNorth, -1* UAVVel.VelDown], t_plot);
out.UAVVelocityQuiver = quiver3(UTM_X, UTM_Y, AGL_Lidar, UAVVel_UTM(:,1)', UAVVel_UTM(:,2)', UAVVel_UTM(:,3)', "DisplayName", "UAVVel", "AutoScaleFactor",autoScaleFactor);

xlabel('X [m]');
ylabel('Y [m]');
zlabel('AGL [m]');
out.leg = legend('show', 'Location', 'north');
grid('on');
colormap('jet');
out.ColorBar = colorbar();
out.ColorBar.Label.String = 'Time [s]';
% cb.Position(1) = cb.Position(1) + 0.1;





end

function [out] = plotPositionSetpoints(dataTrs, out)
% Handle GPS setpoints
if height(dataTrs.FCON_SET_POSITION_SIG) > 0
    P = dataTrs.FCON_SET_POSITION_SIG;
    P.MaxVel = [];
end

% Handle Terrain-follow setpoints.
if height(dataTrs.FCON_SET_TERRAIN_SIG) > 0
    P_TF = dataTrs.FCON_SET_TERRAIN_SIG;
    P_TF.Alt = P_TF.AGL;
    P_TF.AltMode = repmat(2, [1 height(P_TF)]);
    P_TF.AGL = [];
    
    if(exist('P', 'Var'))
       P = vertcat(P, P_TF); 
    else
        P = P_TF;
    end
end

if exist("P", "Var")
    [X,Y,AltAGL,C,Labels] = GetSPData(P, out.X_Ref, out.Y_Ref, dataTrs.AGL, dataTrs.POSITION);
    out.LineSP = scatter3(out.ax, X, Y, AltAGL, 50, C, 'DisplayName', 'SP');
    text(out.ax, X, Y, AltAGL,Labels,'VerticalAlignment','top','HorizontalAlignment','left')
end

end

function [X,Y,AltAGL,C,Labels] = GetSPData(SPData, Origin_X, Origin_Y, AGLData, UAVPos)

    for iSP = 1:height(SPData)
        TimeNow = SPData.Time(iSP);
        X(iSP) = SPData.UTMCoord_x- Origin_X;
        Y(iSP) = SPData.UTMCoord_y - Origin_Y;
        AltAGL(iSP) = SPData.Alt(iSP);
        AGL(iSP) = interp1(AGLData.Time, AGLData.Value, TimeNow);
        C(iSP) = 'g';
       if(SPData.AltMode(iSP) == 1)
           C = 'b';
          AltAGL(iSP) = AltAGL(iSP) - (interp1(UAVPos.Time, UAVPos.Alt, TimeNow) - AGL(iSP));
       end
    Labels{iSP} = sprintf('%d', iSP); 
    
    end


end
