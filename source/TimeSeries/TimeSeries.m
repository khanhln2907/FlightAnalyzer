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
        function [f, X] = fft_analyze(obj, varargin)
            pOption = ParameterParser.parse(varargin{:});
            fs = obj.Info.fs;
            
            

            % Get the time sample segment to perform fft analysis+
            figName =  sprintf("FFT_%s_[%d_s_%d_s]", obj.Info.Name, round(pOption.tMin), round(pOption.tMax));
            timeFilter = (obj.data.Time >= pOption.tMin) & (obj.data.Time <= pOption.tMax);
            orgDataVec = obj.Value;
            
            % Perform FFT
            x = detrend(orgDataVec(timeFilter)) .* hanning(numel(orgDataVec(timeFilter)));
            [f, X] = perform_FFT(x, fs);
            
            % Plotting
            figure_name = sprintf("%s_%s", figName, structInfo.fName(i));
            fig = figure('Name', figure_name, 'Position', get(0, 'Screensize'));
            plot(f, X, '-o');
            hold on; 
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

            xlabel("Freq [Hz]");
            ylabel(sprintf("Magnitude %s", lower(structInfo.interpreterName(i))));
            title(sprintf("FFT of %s \n [%.1f, %.1f] [s] ", obj.topic, pOption.tMin, pOption.tMax), 'Interpreter', 'None')

            pbaspect([4 3 4]) % TODO: bring this out as parameter

            % Saving
            if(isstring(pOption.SavePath))
                savePath = fullfile(pOption.SavePath, "FFT", figName);
                obj.save_figure(fig, savePath, figure_name);
            end
        end
        
        function save_figure(obj, retFig, savePath, figName)
            save_figure(retFig, savePath, figName)
        end
        
    end
    
end

