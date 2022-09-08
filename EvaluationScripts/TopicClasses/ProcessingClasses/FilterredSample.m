classdef FilterredSample < handle
    properties
          
    end
    
    methods
        function obj = FilterredSample()
            
        end
        
        function [ret, org] = get_filterred_topic_sample(obj, topicSample, fPtr)
            info = topicSample.get_analyzed_fieldname();
            ret = topicSample.copy();
            org = topicSample.copy();
            %%
            % Some assertion to ensure the class types ...
            assert (numel(info.fName) == numel(fPtr), "The total amount of filter must equal the number of axes");
            %%
            for i = 1:numel(info.fName)
               org.data.(info.fName{i}) = detrend(org.data.(info.fName{i}));
            end
            
            for i = 1:numel(info.fName)
               ret.data.(info.fName{i}) = fPtr{i}.process(org.data.(info.fName{i}));
            end
            ret.topic = sprintf("%s_Filterred_%s", ret.topic, fPtr{i}.name);
        end
    end
end

