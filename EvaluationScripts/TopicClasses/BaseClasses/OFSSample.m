classdef OFSSample < Sample
    %ATTITUDERATESAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Dx", "Dy"]);
            isValid = all(flag == 1);
        end
        
               
        function [out] = get_analyzed_fieldname(obj)
            out.fName = ["Dx", "Dy"];
            out.unit = "Motions";
            out.interpreterName = ["Dx", "Dy"];
            out.datatype = "OFS";
        end
        
        function dataStruct = get_data_components(obj)
            dataStruct.Time = obj.data.Time;
            dataStruct.Dx = obj.data.Dy;
            dataStruct.Dy = obj.data.Dx;
        end
        
        function obj = outlier(obj)
            thresholdMotions = 100;
            filter = (abs(obj.data.Dx) < thresholdMotions) & (abs(obj.data.Dy) < thresholdMotions) & (obj.data.Time > 1);
            fName = fieldnames(obj.data);
            for i = 1:numel(fName)
               tmp = obj.data.(fName{i});
               tmp(~filter) = [];
               obj.data.(fName{i}) = tmp;
            end
        end
        
        function vbOut =  compute_vb(obj, attRateSample, lidarSample)
            intplLidarSample = lidarSample.interpolate(obj.data.Time); 
            alt = intplLidarSample.data.Distance;
            formular = 3;
            if(formular == 1) % Website https://ardupilot.org/copter/docs/common-mouse-based-optical-flow-sensor-adns3080.html
                gain = 5;
                dpx = gain * (obj.data.Dx .* alt) / (35 * 35 * 1)  * tan(21 * pi / 180);
                dpy = gain * (obj.data.Dy .* alt) / (35 * 35 * 1) * tan(21 * pi / 180);
            elseif(formular == 2) % Master Thesis of Marcus Greiff
                gain = 0.09;
                dpx = gain * 42 * pi / 180 /35  .* alt .* obj.data.Dx;
                dpy = gain * 42 * pi / 180 /35 .* alt .* obj.data.Dy;
            elseif(formular == 3) % Khanhs formular
                gain = 0.20;
                dpx = gain * alt .* tan(obj.data.Dx * 21/35 * pi / 180);
                dpy = gain * alt .* tan(obj.data.Dy * 21/35 * pi / 180);
            end

            %% POST PROCESSING %%%
            filter = (~isnan(dpx)) & (~isnan(dpy) & ~isnan(obj.data.Time));
            
            vbOut.Time = obj.data.Time(filter);
            vbOut.Vx = dpx(filter) * 100;
            vbOut.Vy = dpy(filter) * 100;
        end
        
    end
end

