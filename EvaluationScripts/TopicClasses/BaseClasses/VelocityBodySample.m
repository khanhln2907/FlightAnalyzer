classdef VelocityBodySample < VelocitySample
    %VELOCITYBODYSAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function [out] = get_analyzed_fieldname(obj)
            out.fName = ["Vx", "Vy", "Vz", "VelBodyTotal"];
            out.unit = "m/s";
            out.interpreterName = ["V_x", "V_y", "V_z", "V_b_{abs}"];
            out.datatype = "VELOCITY";
        end
        
        function preprocess_data(obj)
            % Super class method to convert the time stamp from us to s
            preprocess_data@Sample(obj);      
            obj.data.VelBodyTotal = (obj.data.Vx.^2 + obj.data.Vy.^2 + obj.data.Vz.^2).^(1/2);           
        end
        
        
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Vx", "Vy", "Vz"]);
            isValid = all(flag == 1);
        end
        
        
        function to_ned_frame()
            
        end
    end
end

