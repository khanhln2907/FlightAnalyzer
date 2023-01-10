classdef TSInfo < handle
    %TSINFO 
    %   Data structure that contains the information of a time series.
    
    properties
        SensorName
        Measurement
        Unit
        AxisLabel
        fs
    end
    
    methods
        function obj = TSInfo(SensorName, Measurement, Unit, AxisLabel, fs)
            obj.SensorName = SensorName;
            obj.Measurement = Measurement;
            obj.Unit = Unit;
            obj.AxisLabel = AxisLabel;
            obj.fs = fs;
        end
        
        function ret = getLegendName(obj)
            ret = sprintf("%s_%s", obj.SensorName, obj.Measurement);
        end
    end
end

