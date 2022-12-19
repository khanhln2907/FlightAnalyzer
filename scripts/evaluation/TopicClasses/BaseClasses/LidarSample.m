classdef LidarSample < Sample
    %LidarSample Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Distance", "SS"]);
            isValid = all(flag == 1);
        end
        
               
        function [out] = get_analyzed_fieldname(obj)
            out.fName = ["Distance", "SS"];
            out.unit = "Motions";
            out.interpreterName = ["Distance", "SS"];
            out.datatype = "LIDAR";
        end
        
        function dataStruct = get_data_components(obj)
            dataStruct.Time = obj.data.Time;
            dataStruct.Distance = obj.data.Distance;
            dataStruct.SS = obj.data.SS;
        end
        
    end
end

