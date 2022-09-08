classdef TrajectorySample < handle
    %TRAJECTORYSAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modeSample
        rateSample
        attSample
        velNEDSample
        posGPSSample
        
        % Setpoint
        gpsSPSample
        terrainSPSample
        velNEDSPSample
        targetInfoSample
        calctargetDirSample
    end
    
    methods
        function obj = TrajectorySample(varargin)
           p = inputParser;           
           
           addParameter(p, 'GPSPositionSample', []);
           addParameter(p, 'VelNEDSample', []);
           addParameter(p, 'AttitudeSample', []);
           addParameter(p, 'RateSample', []);
           addParameter(p, 'FlightModeSample', []);
           
           addParameter(p, 'GPSSPSample', []);
           addParameter(p, 'TerrainSPSample', []);
           addParameter(p, 'VelNEDSPSample', []);
           addParameter(p, 'TrackingNEDSample', []);
           addParameter(p, 'TargetInfoSample', []);

           parse(p, varargin{:}); 
           obj.modeSample = p.Results.FlightModeSample;
           obj.rateSample = p.Results.RateSample;
           obj.attSample = p.Results.AttitudeSample;
           obj.velNEDSample = p.Results.VelNEDSample;
           obj.posGPSSample = p.Results.GPSPositionSample;
           obj.gpsSPSample = p.Results.GPSSPSample;
           obj.terrainSPSample = p.Results.TerrainSPSample;
           obj.velNEDSPSample = p.Results.VelNEDSPSample;
           obj.targetInfoSample = p.Results.TrackingNEDSample;
           obj.calctargetDirSample = p.Results.TargetInfoSample;
           
           obj.clean_data();
        end
        
        
        
        function obj = clean_data(obj)
           tStart_s = 40;
           
           
            if(~isempty(obj.modeSample))
                obj.modeSample = get_topic_sample_interval(obj.modeSample, tStart_s, inf);
            end

            if(~isempty(obj.attSample))
                obj.attSample = get_topic_sample_interval(obj.attSample, tStart_s, inf);
            end

            if(~isempty(obj.rateSample))
                obj.rateSample = get_topic_sample_interval(obj.rateSample, tStart_s, inf);
            end

            if(~isempty(obj.velNEDSample))
                obj.velNEDSample = get_topic_sample_interval(obj.velNEDSample, tStart_s, inf);
            end

            if(~isempty(obj.posGPSSample))
                obj.posGPSSample = get_topic_sample_interval(obj.posGPSSample, tStart_s, inf);
            end
            
            if(~isempty(obj.gpsSPSample))
                obj.gpsSPSample = get_topic_sample_interval(obj.gpsSPSample, tStart_s, inf);
            end

            if(~isempty(obj.velNEDSPSample))
                obj.velNEDSPSample = get_topic_sample_interval(obj.velNEDSPSample, tStart_s, inf);
            end
            
            if(~isempty(obj.targetInfoSample))
                obj.targetInfoSample = get_topic_sample_interval(obj.targetInfoSample, tStart_s, inf);
            end
            
        end
        
        function h = animate_gps_3d(obj, t_min_s, t_max_s)
            step = 50;
            
            GPSData = get_topic_sample_interval(obj.posGPSSample, t_min_s, t_max_s);
            
            %dt = 0.1 * 1e6; 
            %Timesteps = (GPSData.Time(1): dt: GPSData.Time(end))'; % in microseconds
            
            Timesteps = GPSData.Time; % in microseconds

            GPSData = get_intpl_table(GPSData, Timesteps, "linear");
            fMode = get_intpl_flight_mode(obj.modeSample, Timesteps);
            
            X_Ref = GPSData.UTMCoord_x(1);
            Y_Ref = GPSData.UTMCoord_y(1);

            UAV_X = GPSData.UTMCoord_x - X_Ref;
            UAV_Y = GPSData.UTMCoord_y - Y_Ref;
            UAV_Alt = GPSData.Alt;

            % Interpolate target positions onto UAV data timestamps.
            TARGET = get_intpl_table(obj.posGPSSample, Timesteps, "previous");
            Target_X = TARGET.UTMCoord_x - X_Ref;
            Target_Y = TARGET.UTMCoord_y - Y_Ref;
            Target_Alt = TARGET.Alt;

            % Get tracking data
            TARGET_DIR = get_tracking_target_dir(Timesteps,  obj.modeSample, obj.targetInfoSample);
            
            X_Max = max([UAV_X; Target_X]);
            Y_Max = max([UAV_Y; Target_Y]);
            Alt_Max = max([GPSData.Alt; GPSData.Alt])+5;

            X_Min = min([UAV_X; Target_X]);
            Y_Min = min([UAV_Y; Target_Y]);
            Alt_Min = min([GPSData.Alt; GPSData.Alt])-5;

            h.FigTrajectory = figure('Name', 'Intercept');
            h.axTrajectory = axes();
            h.StemUAV = stem3(h.axTrajectory, UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'IC');
            hold on;

            xlim([X_Min-10 X_Max+10]);
            ylim([Y_Min-10 Y_Max+10]);
            zlim([Alt_Min Alt_Max]);

            h.TrackUAV = plot3(UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'Track UAV', 'Color', 'blue');
            h.StemTrack = stem3(UAV_X(1), UAV_Y(1), UAV_Alt(1), 'DisplayName', 'Track', 'Color', [0.7 0.7 0.9 0.4]);
 
            HideFromLegend(h.TrackUAV);
            HideFromLegend(h.StemTrack);

            % Add velocity vector...
            [vX, vY, vZ] = obj.get_velNED_vector(Timesteps(1), UAV_X(1), UAV_Y(1), UAV_Alt(1), 5);
            [vX_set, vY_set, vZ_set] = obj.get_velNED_sp_vector(Timesteps(1), UAV_X(1), UAV_Y(1), UAV_Alt(1), 5);
            h.VelocityVector = plot3(vX, vY, vZ,'-k.', 'DisplayName', 'IC Vel.');
            h.SetpointVector = plot3(vX_set, vY_set, vZ_set,'->', 'Color', [1 0 0 0.5], 'DisplayName', 'IC Vel. setpoint');

            %h.SetpointDirVector = quiver3(UAV_X(1), UAV_Y(1), UAV_Alt(1), TARGET_DIR.VelEast(1), TARGET_DIR.VelNorth(1), TARGET_DIR.VelDown(1), 10, 'DisplayName', "TargetDir");
            scale = 10;
            h.SetpointDirVector = plot3(scale * [UAV_X(1) TARGET_DIR.VelEast(1)], scale * [UAV_Y(1) TARGET_DIR.VelNorth(1)], scale * [UAV_Alt(1) TARGET_DIR.VelDown(1)], '-*', 'DisplayName', "TargetDir");

            
            h.StemTarget = stem3(h.axTrajectory,Target_X(1), Target_Y(1), Target_Alt(1), 'DisplayName', 'Target');
            legend('show', 'Location', 'northeast');
            xlabel('X [m]');
            ylabel('Y [m]');
            zlabel('Alt [m]');
            T = title(h.axTrajectory,sprintf('Distance = %3.1f m', 0), 'FontSize', 16,'interpreter', 'none');
            
            FormatFigure(gcf, 12, 12/8);

            
            for iTime = 1:25:numel(Timesteps)
                h.StemUAV.XData = UAV_X(iTime);
                h.StemUAV.YData = UAV_Y(iTime);
                h.StemUAV.ZData = UAV_Alt(iTime);

                h.TrackUAV.XData = UAV_X(1:iTime);
                h.TrackUAV.YData = UAV_Y(1:iTime);
                h.TrackUAV.ZData = UAV_Alt(1:iTime);

                [vX, vY, vZ] = obj.get_velNED_vector(Timesteps(iTime), UAV_X(iTime), UAV_Y(iTime), UAV_Alt(iTime), 5);
                [vX_set, vY_set, vZ_set] = obj.get_velNED_sp_vector(Timesteps(iTime), UAV_X(iTime), UAV_Y(iTime), UAV_Alt(iTime), 5);
                h.VelocityVector.XData = vX;
                h.VelocityVector.YData = vY;
                h.VelocityVector.ZData = vZ;

                h.SetpointVector.XData = vX_set;
                h.SetpointVector.YData = vY_set;
                h.SetpointVector.ZData = vZ_set;

                h.StemTarget.XData = Target_X(iTime);
                h.StemTarget.YData = Target_Y(iTime);
                h.StemTarget.ZData = Target_Alt(iTime);
                
                
                % Append the tracking data
                scale = TARGET_DIR.MaxVel(iTime);
                h.SetpointDirVector.XData = [0 scale * TARGET_DIR.VelEast(iTime)] + UAV_X(iTime); 
                h.SetpointDirVector.YData = [0 scale * TARGET_DIR.VelNorth(iTime)] + UAV_Y(iTime);
                h.SetpointDirVector.ZData = [0 -1 * scale * TARGET_DIR.VelDown(iTime)] + UAV_Alt(iTime);

                Distance(iTime) = 0;
                
                T.String = sprintf('t = %4.1f, Distance = %3.1f m, Mode: %s', Timesteps(iTime), Distance(iTime), fMode.FlightMode(iTime));
                
                h.Frames(iTime) = getframe(gcf);            
            end
        end
        
        
            function [vX, vY, vZ] = get_velNED_sp_vector(obj, t, X0, Y0, Z0, Scale)

            if ~exist('Scale', 'Var')
                Scale = 1.0;
            end

                vX(1) = X0;
                vY(1) = Y0;
                vZ(1) = Z0;
                
                vX(2) = interp1(obj.velNEDSPSample.Time, obj.velNEDSPSample.VelEast, t) * Scale + X0;
                vY(2) = interp1(obj.velNEDSPSample.Time, obj.velNEDSPSample.VelNorth, t) * Scale + Y0;
                vZ(2) = -1 * interp1(obj.velNEDSPSample.Time, obj.velNEDSPSample.VelDown, t) * Scale + Z0;

            end

            function [vX, vY, vZ] = get_velNED_vector(obj, t, X0, Y0, Z0, Scale)

                if ~exist('Scale', 'Var')
                    Scale = 1.0;
                end

                vX(1) = X0;
                vY(1) = Y0;
                vZ(1) = Z0;

                vX(2) = interp1(obj.velNEDSample.Time, obj.velNEDSample.VelEast, t) * Scale + X0;
                vY(2) = interp1(obj.velNEDSample.Time, obj.velNEDSample.VelNorth, t) * Scale + Y0;
                vZ(2) = -1 * interp1(obj.velNEDSample.Time, obj.velNEDSample.VelDown, t) * Scale + Z0;
            end

            function h = plot_flight_mode(obj, ax)
                if ~exist('ax', 'Var')
                    h.FigTrajectory = figure('Name', 'Intercept');
                    h.ax = axes();
                end
                
                h = plot(h.ax, obj.modeSample.Time / 1e6, obj.modeSample.FlightMode, "-o");
                xlabel("Time [s]");
                
                if ~exist('ax', 'Var')
                    set(groot, 'DefaultAxesTickLabelInterpreter', 'none')
                    FormatFigure(gcf, 12, 12/8);
                end
                
            end
            
    end
end








