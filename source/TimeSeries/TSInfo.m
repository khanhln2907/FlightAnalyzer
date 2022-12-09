classdef TSInfo < handle
    %TSINFO 
    %   Data structure that contains the information of a time series.
    
    properties
        Name
        Unit
        AxisLabel
        fs
    end
    
    methods
        function obj = TSInfo(Name, Unit, AxisLabel, fs)
            obj.Name = Name;
            obj.Unit = Unit;
            obj.AxisLabel = AxisLabel;
            obj.fs = fs;
        end
    end
end

