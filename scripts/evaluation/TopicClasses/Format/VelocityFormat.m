classdef VelocityFormat < SampleFormat
    %VELOCITYFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = VelocityFormat()
            obj.fName = ["VelNorth", "VelEast", "VelDown", "VelTotal"];
            obj.unit = "m/s";
            obj.interpreterName = ["V_N", "V_E", "V_D", "V_{total}"];
            obj.datatype = "VELOCITY";
        end
        
    end
end

