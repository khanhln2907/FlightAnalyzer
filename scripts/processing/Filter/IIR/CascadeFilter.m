classdef CascadeFilter < handle
    %IIRFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        n
        SOS
        BiquadDF2Arr
        preScale
        gain 
    end
    
    methods
        function obj = CascadeFilter(nSection, sosMatrix, scaleFactor, name)
           obj.n = nSection;
           obj.SOS = sosMatrix;
           obj.BiquadDF2Arr = BiquadDF2.empty(nSection, 0);
           for i = 1 : obj.n
               obj.BiquadDF2Arr(i) = BiquadDF2(obj.SOS(i, :));
           end
           obj.preScale = scaleFactor(1);
           obj.gain = scaleFactor(2:end);
           obj.name = name;
        end
        
        function out = compute(obj,input)
           out = input *  obj.preScale;
           for i = 1 : obj.n
              out = obj.BiquadDF2Arr(i).compute(out * obj.gain(i));
           end
        end
        
        function out = process(obj, input)
            out = zeros(size(input));
            for i = 1:numel(input)
                % Direct form II calculation
                out(i) = obj.compute(input(i));
            end
        end
    end
end

