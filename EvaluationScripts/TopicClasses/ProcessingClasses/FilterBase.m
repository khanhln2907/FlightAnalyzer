classdef FilterBase < handle
    
    properties
        
    end
    
    methods
        function obj = FilterBase()
            
        end
        
        
        function topicOut = process(obj, topicSample)
            payload = topicSample.get_data_components();
            fName = fieldnames(payload);
            fName = fName(fName ~= "Time");
            for i = 1:numel(fName)
               topicOut.(fName{i}) = obj.filter(payload.(fName{i})); 
            end
            topicOut.Time = payload.Time;
        end
        
        function out = lp_filter(obj, x, fc, fs)
            out = lowpass(x,fc,fs, 'Steepness',0.95);
        end
        
    end
end

