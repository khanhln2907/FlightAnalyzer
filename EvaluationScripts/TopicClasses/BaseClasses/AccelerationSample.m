classdef AccelerationSample < Sample
    %AccelerationSAMPLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods

        
        function preprocess_data(obj)
            % Super class method to convert the time stamp from us to s
            preprocess_data@Sample(obj);      
            obj.data.aTotal = (obj.data.Ax.^2 + obj.data.Ay.^2 + obj.data.Az.^2).^(1/2);
            
        end
        
        function obj = set_data_format(obj)
           obj.dataFormat = AccelerationFormat;
        end
        
        function [out] = get_analyzed_fieldname(obj)
            out = obj.dataFormat;
        end
        
        function isValid = check_data_format(obj)
            flag = isfield(obj.data, ["Time", "Ax", "Ay", "Az"]);
            isValid = all(flag == 1);
        end
        
        function [retFig, name] = plot_time_domain_merge(obj, varargin)
            [iParam] = ParameterParser.parse(varargin{:});
            filter = (obj.data.Time > iParam.tMin) & (obj.data.Time < iParam.tMax);
            name = sprintf("Time_series_%s_%s_%s", obj.topic, string(iParam.tMin), string(iParam.tMax));
            
            retFig = figure("Name", name);
            plot(obj.data.Time(filter), obj.data.Ax(filter), "-o", "DisplayName", obj.topic + " x");
            hold on; grid on; grid minor;
            plot(obj.data.Time(filter), obj.data.Ay(filter), "-o", "DisplayName", obj.topic + " y");
            plot(obj.data.Time(filter), obj.data.Az(filter), "-o", "DisplayName", obj.topic + " z");
            legend('Interpreter', 'none');
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
            xlabel("Time [s]");
            ylabel("Acceleration [m/s^2]");
            title(obj.topic, 'Interpreter', 'none');
            
            if(isstring(iParam.SavePath))
                obj.save_figure(fig, savePath);
            end
        end
        
        
        
    end
end
