function [h] = plot_HomeToTarget(HomingData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tMin = max(HomingData.GPS.Time(1), HomingData.Target.Time(1));
tMax = min(HomingData.GPS.Time(end), HomingData.Target.Time(end));
% tMax = max(HomingData.GPS.Time(end));

dt = 0.5; % Timestep between 'old' stems to be drawn

Timesteps = HomingData.GPS.Time((HomingData.GPS.Time >= tMin ) &...
    (HomingData.GPS.Time <= tMax));


h.FigTrajectory = figure('Name', 'Intercept');
h.axTrajectory = axes();
% hold on;
% h.axDistance = subplot(2,1,2);

X_Ref = HomingData.GPS.utm_x(1);
Y_Ref = HomingData.GPS.utm_y(2);

% Interpolate target positions onto UAV data timestamps.
Target_X = interp1(HomingData.Target.Time, HomingData.Target.utm_x, Timesteps, 'nearest') - X_Ref;
Target_Y = interp1(HomingData.Target.Time, HomingData.Target.utm_y, Timesteps, 'nearest') - Y_Ref;
Target_Alt = interp1(HomingData.Target.Time, HomingData.Target.Alt, Timesteps, 'nearest');

GPSData = HomingData.GPS;
UAV_X = GPSData.utm_x - X_Ref;
UAV_Y = GPSData.utm_y - Y_Ref;
UAV_Alt = GPSData.Alt;

% Fix erraneous GPS data...
idx = find(UAV_Y  < -500, 1);

UAV_X(idx) = UAV_X(idx+1);
UAV_Y(idx) = UAV_Y(idx+1);
UAV_Alt(idx) = UAV_Alt(idx+1);


X_Max = max([UAV_X; Target_X]);
Y_Max = max([UAV_Y; Target_Y]);
Alt_Max = max([HomingData.GPS.Alt; HomingData.Target.Alt])+5;

X_Min = min([UAV_X; Target_X]);
Y_Min = min([UAV_Y; Target_Y]);
Alt_Min = min([HomingData.GPS.Alt; HomingData.Target.Alt])-5;

    
for iTime = 1:length(Timesteps)
    
    t = Timesteps(iTime);
    
    idxUAV = find(GPSData.Time == t, 1);
    
    Distance(iTime) = sqrt((Target_X(iTime) - UAV_X(idxUAV))^2 + (Target_Y(iTime) - UAV_Y(idxUAV))^2 + (Target_Alt(iTime) - UAV_Alt(idxUAV))^2);
        
    % Prepare plot
     if iTime == 1
        h.StemUAV = stem3(h.axTrajectory, UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'IC');
        hold on;
        
        xlim([X_Min X_Max]);
        ylim([Y_Min Y_Max]);
        zlim([Alt_Min Alt_Max]);
        
        h.TrackUAV = plot3(UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'Track UAV', 'Color', 'blue');
        
%         [X, Y, Z] = GetPatchVertices(UAV_X, UAV_Y, UAV_Alt, 2);       
%         h.TrackSurfUAV = fill3(X', Y', Z', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
%         HideFromLegend(h.TrackSurfUAV);
        h.StemTrack = stem3(UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'Track', 'Color', [0.7 0.7 0.9 0.4]);
        lastTrackTime = t;

        HideFromLegend(h.TrackUAV);
        HideFromLegend(h.StemTrack);

        % Add velocity vector...
        [vX, vY, vZ] = GetVelocityVector(HomingData, t, UAV_X(1), UAV_Y(1), UAV_Alt(1), 5);
        [vX_set, vY_set, vZ_set] = GetSetpointVector(HomingData, t, UAV_X(1), UAV_Y(1), UAV_Alt(1), 5);
%         h.Arrow = mArrow3([UAV_X(1) UAV_Y(1) UAV_Alt(1)], [vX(2) vY(2) vZ(2)]);
        h.VelocityVector = plot3(vX, vY, vZ,'-k.', 'DisplayName', 'IC Vel.');
        h.SetpointVector = plot3(vX_set, vY_set, vZ_set,'->', 'Color', [1 0 0 0.5], 'DisplayName', 'IC Vel. setpoint');
%         HideFromLegend(h.VelocityVector);
                
                
        h.StemTarget = stem3(h.axTrajectory,Target_X(iTime), Target_Y(iTime), Target_Alt(iTime), 'DisplayName', 'Target');

        legend('show', 'Location', 'northeast');
        
        T = title(h.axTrajectory,sprintf('Distance = %3.1f m', Distance(iTime)), 'FontSize', 16);
%         Line = line([UAV_X, Target_X], [UAV_Y, Target_Y], [UAV_Alt, Target_Alt], 'Color', 'red');
        xlabel('X [m]');
        ylabel('Y [m]');
        zlabel('Alt [m]');
        

        
        FormatFigure(gcf, 12, 12/8);
     else
        h.StemUAV.XData = UAV_X(iTime);
        h.StemUAV.YData = UAV_Y(iTime);
        h.StemUAV.ZData = UAV_Alt(iTime);
        
        h.TrackUAV.XData = UAV_X(1:iTime);
        h.TrackUAV.YData = UAV_Y(1:iTime);
        h.TrackUAV.ZData = UAV_Alt(1:iTime);
        
        [vX, vY, vZ] = GetVelocityVector(HomingData, t, UAV_X(iTime), UAV_Y(iTime), UAV_Alt(iTime), 3);
        [vX_set, vY_set, vZ_set] = GetSetpointVector(HomingData, t, UAV_X(iTime), UAV_Y(iTime), UAV_Alt(iTime), 3);
        h.VelocityVector.XData = vX;
        h.VelocityVector.YData = vY;
        h.VelocityVector.ZData = vZ;
        
        h.SetpointVector.XData = vX_set;
        h.SetpointVector.YData = vY_set;
        h.SetpointVector.ZData = vZ_set;
        
        if t - lastTrackTime >= dt
            lastTrackTime = t;
            
            h.StemTrack.XData = [ h.StemTrack.XData UAV_X(iTime)];
            h.StemTrack.YData = [ h.StemTrack.YData UAV_Y(iTime)];
            h.StemTrack.ZData = [ h.StemTrack.ZData UAV_Alt(iTime)];
        end
        
%         [X, Y, Z] = GetPatchVertices(UAV_X, UAV_Y, UAV_Alt, iTime);
%         h.TrackSurfUAV.XData = horzcat(h.TrackSurfUAV.XData, X);
%         h.TrackSurfUAV.YData = horzcat(h.TrackSurfUAV.YData, Y);
%         h.TrackSurfUAV.ZData = horzcat(h.TrackSurfUAV.ZData, Z);
        
        h.StemTarget.XData = Target_X(iTime);
        h.StemTarget.YData = Target_Y(iTime);
        h.StemTarget.ZData = Target_Alt(iTime);
        T.String = sprintf('t = %4.1f, Distance = %3.1f m', Timesteps(iTime), Distance(iTime));
        
%         h.Target = stem3(Target_Lat, Target_Long, Target_Alt, 'DisplayName', 'Target');
     end
%     drawnow;
    
    h.Frames(iTime) = getframe(gcf);
end


%% Plot distance over time
h.FigDistance = figure('Name', 'Distance');
h.axDistance = axes();
h.LineDistance = plot(Timesteps, Distance, 'DisplayName', 'Distance');

xlabel(h.axDistance,'Time [s]');
ylabel(h.axDistance,'Distance [m]');
title(sprintf('Min distance: %2.1f [m]', min(Distance)));
FormatFigure(gcf, 12, 12/8);
h.MinDistance = min(Distance);

idx = find(Distance == min(Distance));
% Save Target position at closest encounter
h.Target_X_dMin = Target_X(idx);
h.Target_Y_dMin = Target_Y(idx);
h.Target_Alt_dMin = Target_Alt(idx);
h.Time_Closest = Timesteps(idx);


end


function [vX, vY, vZ] = GetSetpointVector(HomingData, t, X0, Y0, Z0, Scale)

if ~exist('Scale', 'Var')
    Scale = 1.0;
end

    vX(1) = X0;
    vY(1) = Y0;
    vZ(1) = Z0;

    vX(2) = interp1(HomingData.FCON_SP_Vel.Time, HomingData.FCON_SP_Vel.VelE, t) * Scale + X0;
    vY(2) = interp1(HomingData.FCON_SP_Vel.Time, HomingData.FCON_SP_Vel.VelN, t) * Scale + Y0;
    vZ(2) = -1 * interp1(HomingData.FCON_SP_Vel.Time, HomingData.FCON_SP_Vel.VelD, t) * Scale + Z0;

end

function [vX, vY, vZ] = GetVelocityVector(HomingData, t, X0, Y0, Z0, Scale)

if ~exist('Scale', 'Var')
    Scale = 1.0;
end

    vX(1) = X0;
    vY(1) = Y0;
    vZ(1) = Z0;

    vX(2) = interp1(HomingData.GPS.Time, HomingData.GPS.V_east, t) * Scale + X0;
    vY(2) = interp1(HomingData.GPS.Time, HomingData.GPS.V_north, t) * Scale + Y0;
    vZ(2) = -1 * interp1(HomingData.GPS.Time, HomingData.GPS.V_down, t) * Scale + Z0;

end


function [X, Y, Z] = GetPatchVertices(XVec, YVec, ZVec, idx)

func = @(i,V)([V(i-1); V(i); V(i); V(i-1)]);

X = func(idx,XVec);
Y = func(idx,YVec);
Z = [ZVec(idx-1); ZVec(idx); 0; 0];

end
