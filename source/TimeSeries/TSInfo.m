classdef TSInfo < handle
    %TSINFO 
    %   Data structure that contains the information of a time series.
    
    properties
        Name
        Unit
        AxisLabel
    end
    
    methods
        function obj = TSInfo(Name, Unit, AxisLabel)
            obj.Name = Name;
            obj.Unit = Unit;
            obj.AxisLabel = AxisLabel;
        end
    end
end

