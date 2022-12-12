classdef TopicInfo
    %TOPICINFO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Source 
        DataFields 
        Unit 
        AxisLabel
        fs
    end
    
    methods
        function obj = TopicInfo(s, d, u, a, f)
            obj.Source = s;
            obj.DataFields = d;
            obj.Unit = u;
            obj.AxisLabel = a;
            obj.fs = f;
        end
    end
end

