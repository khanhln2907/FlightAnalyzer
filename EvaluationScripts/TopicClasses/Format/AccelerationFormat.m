classdef AccelerationFormat < SampleFormat
    %ACCELERATIONFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AccelerationFormat()
            obj.fName = ["Ax", "Ay", "Az"];
            obj.unit = "m/s^2";
            obj.interpreterName = ["a_x", "a_y", "a_z"];
            obj.datatype = "ACCELERATION";
        end
    end
end

