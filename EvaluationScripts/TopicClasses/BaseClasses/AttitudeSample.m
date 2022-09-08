classdef AttitudeSample < Sample
    %ATTITUDESAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Phi", "Theta", "Psi"]);
            isValid = all(flag == 1);
        end
        
        function obj = set_data_format(obj)
           obj.dataFormat = AttitudeFormat;
        end
        
        function [out] = get_analyzed_fieldname(obj)
            out = obj.dataFormat;
        end
        
        function dataStruct = get_data_components(obj)
            dataStruct.Time = obj.data.Time;
            dataStruct.Phi = obj.data.Phi;
            dataStruct.Theta = obj.data.Theta;
            dataStruct.Psi = obj.data.Psi;
        end
        
    end
end

