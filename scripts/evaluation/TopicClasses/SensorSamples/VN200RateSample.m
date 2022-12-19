classdef VN200RateSample < AttitudeRateSample 
    %VN200SAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        
        function obj = VN200RateSample(rateTable, fs)
            obj = obj@AttitudeRateSample("VN200", rateTable, fs);
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

