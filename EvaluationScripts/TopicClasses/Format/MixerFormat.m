classdef MixerFormat < SampleFormat
    %VELOCITYFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = MixerFormat()
            obj.fName = ["Tx", "Ty", "Tz", "Fz"];
            obj.unit = "N";
            obj.interpreterName = ["Tx", "Ty", "Tz", "Fz"];
            obj.datatype = "MIXER";
        end
        
    end
end

