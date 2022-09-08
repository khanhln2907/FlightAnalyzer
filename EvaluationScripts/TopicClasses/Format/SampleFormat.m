classdef SampleFormat < handle & matlab.mixin.Copyable
    %SAMPLEFORMAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fName 
        unit 
        interpreterName 
        datatype 
    end
    
    methods
        function out = set_format_single(obj, field)
            out = copy(obj);
            [tf, idx] = ismember(out.fName(:), field);
            assert(any(tf));
            id = find(idx,1);
            out.interpreterName = out.interpreterName(id);
            out.fName = out.fName(id);
        end
    end
end

