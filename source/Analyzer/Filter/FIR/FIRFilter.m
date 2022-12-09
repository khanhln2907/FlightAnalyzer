classdef FIRFilter < handle
    properties
        coeff
        buffer
    end
    
    methods
        function obj = FIRFilter(coeff)
            obj.coeff = coeff;            
            obj.buffer = zeros(numel(coeff),1);
        end
        
        function out = compute(obj, x)
            obj.buffer = [obj.buffer(2:end); x];
            out = 0;
            n = numel(obj.coeff);
            for i = 1:n-1 
               out = out + obj.buffer(n-i) * obj.coeff(i);
            end
        end
        
        function out = compute_time_series(obj, time_series)
            out = zeros(numel(time_series),1);
            for i = 1:numel(time_series)
                out(i) = obj.compute(time_series(i));
            end
        end
        
    end
end

