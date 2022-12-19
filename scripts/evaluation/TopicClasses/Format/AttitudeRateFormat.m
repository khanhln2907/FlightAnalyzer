classdef AttitudeRateFormat < SampleFormat
    %ATTITUDERATEFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AttitudeRateFormat()
            obj.fName = ["p", "q", "r"];
            obj.unit = "rad/s";
            obj.interpreterName = ["p", "q", "r"];
            obj.datatype = "ATTITUDE_RATE";
        end
    end
end

