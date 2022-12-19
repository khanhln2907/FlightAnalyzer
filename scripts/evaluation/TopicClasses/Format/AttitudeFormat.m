classdef AttitudeFormat < SampleFormat
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AttitudeFormat()
            obj.fName = ["Phi", "Theta", "Psi"];
            obj.unit = "°";
            obj.interpreterName = ["Phi", "Theta", "Psi"];
            obj.datatype = "ATTITUDE";
        end
    end
end

