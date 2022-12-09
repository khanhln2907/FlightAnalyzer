classdef TimeSeries < handle 
    properties
        %% Attribute
        Time
        Value
        Info % <file:///G:/Workspace/Analyzer/FlightAnalyzer/source/TimeSeries/html/TSInfo.html> 
    end
    
    methods    
        %% TimeSeries
        function obj = TimeSeries(Time, Value, Info)
           obj.Time = Time;
           obj.Value = Value;
           obj.Info = Info;
           
           % Preprocess the time series. E.g., outlier reduntdant timestamp
           % sample, check matching dimension of Time and Value vector, ...
           obj.preprocess_data();
        end
        
        %% preprocess_data 
        % Preprocessing method is called after the instance is constructed.
        function preprocess_data(obj)
           
        end
           
        %% get_data_segments
        % Generate a time series within a specific time interval. 
        function ret = get_data_segments(obj, tS, tE)
            ret = copy(obj);
            ret.Time = ret.Time(ret.Time <= tE && ret.Time >= tS);
            ret.Value = ret.Value(ret.Time <= tE && ret.Time >= tS);
        end
        
        
        %% fft_analyze
        % Perform fft analysis according to the given sampling frequency
        % fs. Check "TimeInterval" option in the parser for better
        % resolution!
        function [f, X] = fft_analyze(obj, varargin)
            pOption = Parser.parse(varargin{:});
            fs = obj.Info.fs;

            % Get the time sample segment to perform fft analysis+
            figName =  sprintf("FFT_%s_[%d_s_%d_s]", obj.Info.Name, round(pOption.tMin), round(pOption.tMax));
            timeFilter = (obj.Time >= pOption.tMin) & (obj.Time <= pOption.tMax);
            orgDataVec = obj.Value;
            
            % Perform FFT
            x = detrend(orgDataVec(timeFilter)); % .* hanning(numel(orgDataVec(timeFilter)));
            [f, X] = perform_FFT(x, fs);
            
            % Plotting
            figure_name = sprintf("%s_%s", figName, obj.Info.AxisLabel);
            fig = figure('Name', figure_name, 'Position', get(0, 'Screensize'));
            plot(f, X, '-o');
            hold on; 
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

            xlabel("Freq [Hz]");
            ylabel(sprintf("Magnitude %s", lower(obj.Info.AxisLabel)));
            title(sprintf("FFT of %s \n [%.1f, %.1f] [s] ", obj.Info.Name, pOption.tMin, pOption.tMax), 'Interpreter', 'None')

            pbaspect([4 3 4]) % TODO: bring this out as parameter

            % Saving
%             if(isstring(pOption.SavePath))
%                 savePath = fullfile(pOption.SavePath, "FFT", figName);
%                 obj.save_figure(fig, savePath, figure_name);
%             end
        end
        
        
        %% plot()
        % Plot the time series 
        function [retFig, name] = plot(obj, varargin)
            [param] = Parser.parse(varargin{:});
            name = sprintf("Time_series_3_axes_%s_%s_%s", obj.Info.Name, string(param.tMin), string(param.tMax));
            
            % Plotting            
            retFig = figure("Name", name);
            tFilter = (obj.Time >= param.tMin) & (obj.Time < param.tMax);

            line = plot(obj.Time(tFilter), obj.Value(tFilter), '-o', "DisplayName", obj.Info.AxisLabel);
            ylabel(sprintf("%s [%s]", obj.Info.Name, obj.Info.AxisLabel));
    
            xlabel("Time [s]");
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
            
            if(isstring(param.SavePath))
                savePath = fullfile(param.SavePath, sprintf("%s", obj.topic));
                obj.save_figure(retFig, savePath, name);
            end
        end
        
        
        function save_figure(obj, retFig, savePath, figName)
            save_figure(retFig, savePath, figName)
        end
        
    end
    
end

