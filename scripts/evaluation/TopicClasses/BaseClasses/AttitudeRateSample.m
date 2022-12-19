classdef AttitudeRateSample < Sample
    %ATTITUDERATESAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "p", "q", "r"]);
            isValid = all(flag == 1);
        end
        
%         function [retFig, name] = quick_plot_time_domain(obj, varargin)
%             [tMin, tMax] = ParameterParser.get_time_param(varargin{:});
%             filter = (obj.data.Time > tMin) & (obj.data.Time < tMax);
%             name = sprintf("Time_series_%s_%s_%s", obj.topic, string(tMin), string(tMax));
%             % Get the data in the interval [tMin, tMax]
%             sampleSegment = get_data_segments(obj, tMin, tMax);
%             
%             % Plotting
%             retFig = figure("Name", name);
%             plot(sampleSegment.data.Time(filter), sampleSegment.data.p(filter), "-o", "DisplayName", sampleSegment.topic + " p");
%             hold on; grid on; grid minor;
%             plot(sampleSegment.data.Time(filter), sampleSegment.data.q(filter), "-o", "DisplayName", sampleSegment.topic + " q");
%             plot(sampleSegment.data.Time(filter), sampleSegment.data.r(filter), "-o", "DisplayName", sampleSegment.topic + " r");
%             legend('Interpreter', 'none');
%             FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
%             xlabel("Time [s]");
%             ylabel("Attitutde Rate [rad/s]");
%             title(obj.topic, 'Interpreter', 'none');
%         end
        
        function obj = set_data_format(obj)
           obj.dataFormat = AttitudeRateFormat;
        end

        function [out] = get_analyzed_fieldname(obj)
            out = obj.dataFormat;
        end
        
        function dataStruct = get_data_components(obj)
            dataStruct.Time = obj.data.Time;
            dataStruct.p = obj.data.p;
            dataStruct.q = obj.data.q;
            dataStruct.r = obj.data.r;
        end
        
    end
end

