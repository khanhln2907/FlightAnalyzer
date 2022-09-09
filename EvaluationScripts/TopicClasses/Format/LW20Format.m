classdef LW20Format < SampleFormat
    %ACCELERATIONFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = LW20Format()
            obj.fName = ["Distance", "SS1"];
            obj.unit = "m";
            obj.interpreterName = ["Distance", "SS"];
            obj.datatype = "LW20";
        end
    end
end


