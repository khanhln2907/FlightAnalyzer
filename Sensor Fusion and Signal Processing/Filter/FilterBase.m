classdef FilterBase < handle
    
    properties
        
    end
    
    methods
        function obj = FilterBase()
            
        end
        
        function topicOut = process(obj, topicSample)
            error "NotImplemented";
        end
        
    end
end

