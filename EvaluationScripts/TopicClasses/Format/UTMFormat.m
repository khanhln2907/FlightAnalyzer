classdef UTMFormat < SampleFormat
    %VELOCITYFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = UTMFormat()
            obj.fName = ["UTMCoord_x", "UTM_Coord_y"];
            obj.unit = "m";
            obj.interpreterName = ["UTMCoord_x", "UTM_Coord_y"];
            obj.datatype = "UTM Coord";
        end
        
    end
end

