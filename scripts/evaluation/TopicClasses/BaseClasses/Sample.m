classdef Sample < handle & matlab.mixin.Copyable
    properties
        topic
        data
        saveFigurePath
        fs
        dataFormat
    end
    
    methods    
        %% Constructor
        % Assign the samples with topicname, sample values (timestamp,
        % data), and the sampling frequency.
        function obj = Sample(topicName, sampleTable, fs)
            obj.topic = topicName;
            obj.fs = fs;
            
            if(istable(sampleTable))
                obj.data = table2struct(sampleTable, "ToScalar", true);
            elseif(isstruct(sampleTable))
                obj.data = sampleTable;
            end
            % Perform some preprocessing if necessary
            % For example: adding total acceleration/velocity/... into the handle
            obj.preprocess_data()
            
            % Check if the sample is succesfully constructed
            isValid = obj.check_data_format();
            assert(isValid, sprintf("Data Format of topic %s is invalid.", topicName));

            %obj.dataFormat = dataFormat; 
            obj.set_data_format();
        end
    
        %% Verification of data type
        % Child class must declare the specific data types it contains to
        % avoid error during the analysis
        function isValid = check_data_format(obj)
            isValid = false;
        end
        
        
        %% Preprocessing callback function
        % The callback function called in the constructor. Child class can
        % overload this function to perform some desired actions, e.g.,
        % axis alligment, mean value computation, add total velocity, etc. 
        function preprocess_data(obj)
           if(isfield(obj.data, "Time"))
              obj.data.Time = obj.data.Time/ 1e6; % Convert us to s 
           end
        end
           
        %% Duplicate to create a sample instance in a specific time interval
        % Sometimes the analysis required a specific data segments. This
        % function make a copy of the object and return all the feature
        % values in the given time interval.
        function copySegment = get_data_segments(obj, tS, tE)
            copySegment = copy(obj);
            fNames = fieldnames(obj.data);
            for i = 1: numel(fNames)
                try
                    copySegment.data.(fNames{i}) = obj.data.(fNames{i})((obj.data.Time < tE) & (obj.data.Time > tS));
                catch
                    continue
                end
            end
        end
        
        %% Interpolate a sample to the given timestamp
        % Todo: now we are just using the simple linear interpolation
        function outSample = interpolate(obj, timeIntpl)
            outSample = copy(obj);
            fNames = fieldnames(outSample.data);
            outSample.topic = append(obj.topic, "_Interpolated");
            for i = 1: numel(fNames)
                try
                    orgData = outSample.data.(fNames{i});
                    intplData =  interp1(obj.data.Time, orgData, timeIntpl);
                    outSample.data.(fNames{i}) = intplData; %intplData(~isnan(intplData)); TODO: avoid dimension mismatching
                catch ME
                    fprintf("Some data struct can't be interpolated. \n %s ", ME.message);
                    continue;
                end
            end
        end
        
        %% Plot Single Merge
        % Plot all data values in one figure
        function [retFig, name] = plot_time_domain_single_figure_merge(obj, varargin)
            [param] = ParameterParser.parse(varargin{:});
            name = sprintf("Time_series_%s_%s_%s", obj.topic, string(param.tMin), string(param.tMax));
            [structInfo] = obj.get_analyzed_fieldname();
            
            % Plotting            
            retFig = figure("Name", name);
            tFilter = (obj.data.Time >= param.tMin) & (obj.data.Time < param.tMax);
            for i = 1:numel(structInfo.fName)
                line = plot(obj.data.Time(tFilter), obj.data.(structInfo.fName(i))(tFilter), '-o', "DisplayName", structInfo.fName(i));
                hold on;
            end
            
            title(obj.topic, 'Interpreter','None',  'FontSize',25);
            ylabel(sprintf("%s [%s]", structInfo.datatype, structInfo.unit));
            xlabel("Time [s]");
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
            legend;
            if(isstring(param.SavePath))
                savePath = fullfile(param.SavePath, sprintf("%s", obj.topic));
                obj.save_figure(retFig, savePath, name);
            end
        end
        
        %% Plot Single
        % Plot each data axis in a new figure
        function [retFig, name] = plot_time_domain_single_figure(obj, varargin)
            [param] = ParameterParser.parse(varargin{:});
            name = sprintf("Time_series_3_axes_%s_%s_%s", obj.topic, string(param.tMin), string(param.tMax));
            [structInfo] = obj.get_analyzed_fieldname();
            
            % Plotting            
            retFig = figure("Name", name);
            tFilter = (obj.data.Time >= param.tMin) & (obj.data.Time < param.tMax);
            for i = 1:numel(structInfo.fName)
                ax(i) = subplot(numel(structInfo.fName), 1, i);
                line = plot(obj.data.Time(tFilter), obj.data.(structInfo.fName(i))(tFilter), '-o', "DisplayName", structInfo.fName(i));
                hold on;
                ylabel(sprintf("%s [%s]", structInfo.interpreterName(i), structInfo.unit));
            end
            
            sgtitle(obj.topic, 'Interpreter','None',  'FontSize',25);

            xlabel("Time [s]");
            linkaxes(ax, "x");           
            FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
            
            if(isstring(param.SavePath))
                savePath = fullfile(param.SavePath, sprintf("%s", obj.topic));
                obj.save_figure(retFig, savePath, name);
            end
        end
        
        %% Plot Single Subplots
        % Plot each data axis in a subplot of one figure
        function [retFig, name] = plot_time_domain_multi_figure(obj, varargin)
            [param] = ParameterParser.parse(varargin{:});
            [structInfo] = obj.get_analyzed_fieldname();
            % Plotting            
            tFileter = (obj.data.Time >= param.tMin) & (obj.data.Time < param.tMax);
            for i = 1:numel(structInfo.fName)
                name = sprintf("Time_series_3_axes_%s_%s_%s_%s", obj.topic, string(param.tMin), string(param.tMax),  structInfo.fName(i));
                retFig = figure("Name", name);
                line = plot(obj.data.Time(tFileter), obj.data.(structInfo.fName(i))(tFileter), '-o', "DisplayName", structInfo.fName(i));
                hold on;
                ylabel(sprintf("%s [%s]", structInfo.interpreterName(i), structInfo.unit));
                
                
                title(obj.topic, 'Interpreter','None',  'FontSize',25);                
                xlabel("Time [s]");
                %linkaxes(ax, "x");           
                FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
                if(isstring(param.SavePath))
                    savePath = fullfile(param.SavePath, sprintf("%s", obj.topic));
                    obj.save_figure(retFig, savePath, name);
                end
            end
        end
        
        % Use this function to generate and save multiple figures in a
        % folder. % TODO: bring this class to TopicVisualizable or something
        function quick_plot_time_domain()
           error "Not defined"; 
        end
        
        
        %% Declare the specific data axes
%         function dataStruct = get_data_cross_analyzed(obj)
%             error "NotImplemented"
%         end
        
        function dataStruct = get_data_cross_analyzed(obj, varargin)
            param = ParameterParser.parse(varargin{:});
            dataStruct = copy(obj);
            [structInfo] = dataStruct.get_analyzed_fieldname();
            filter = (dataStruct.data.Time > param.tMin) & (dataStruct.data.Time < param.tMax);
            dataStruct.data.Time = dataStruct.data.Time(filter);
            % Take the sample segment
            for i = 1:numel(structInfo.fName)
                dataStruct.data.(structInfo.fName(i)) = obj.data.(structInfo.fName(i))(filter);
            end
        end
        
        function obj = set_data_format(obj)
           error "NotImplemented"
        end
        
        function dataStruct = get_data_components(obj)
            error "NotImplemented"
        end
        
        function [info] = get_analyzed_fieldname(obj)
            info = obj.dataFormat;
        end
        
        function ret = get_single_topic_sample(obj, fieldname)
            ret = copy(obj);
            ret.dataFormat = ret.dataFormat.set_format_single(fieldname);
            ret.data = [];
            ret.data.Time = obj.data.Time;
            ret.data.(fieldname) = obj.data.(fieldname);
            ret.topic = sprintf("%s_%s", obj.topic, ret.dataFormat.interpreterName);
        end
            
        function out = lp_filter(obj, fPtr, fc)
            out = copy(obj);
            [structInfo] = obj.get_analyzed_fieldname();
            for i = 1:numel(structInfo.fName)
               out.data.(structInfo.fName{i}) = fPtr.lp_filter(out.data.(structInfo.fName{i}), fc, obj.fs); 
            end
            out.topic = sprintf("%s_Post_Filterred", obj.topic);
        end
        
        function [f, X] = fft_analyze(obj, varargin)
            pOption = ParameterParser.parse(varargin{:});
            fs = obj.fs; % In case we want to try with different frequency from the parser?
            
            % TODO: implement a class to analyze the FFT with some special
            % function instead of directly implemented here
            structInfo = obj.get_analyzed_fieldname();
            
            figName =  sprintf("FFT_%s_[%d_s_%d_s]", obj.topic, round(pOption.tMin), round(pOption.tMax));
            timeFilter = (obj.data.Time >= pOption.tMin) & (obj.data.Time <= pOption.tMax);
            for i = 1:numel(structInfo.fName)
                orgDataVec = obj.data.(structInfo.fName{i});
                x = detrend(orgDataVec(timeFilter)) .* hanning(numel(orgDataVec(timeFilter)));
                [f, X] = perform_FFT(x, fs);
                
                figure_name = sprintf("%s_%s", figName, structInfo.fName(i));
                fig = figure('Name', figure_name, 'Position', get(0, 'Screensize'));
                plot(f, X, '-o');
                hold on; 
                FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

                xlabel("Freq [Hz]");
                ylabel(sprintf("Magnitude %s", lower(structInfo.interpreterName(i))));
                title(sprintf("FFT of %s \n [%.1f, %.1f] [s] ", obj.topic, pOption.tMin, pOption.tMax), 'Interpreter', 'None')
                
                pbaspect([4 3 4]) % TODO: bring this out as parameter

                if(isstring(pOption.SavePath))
                    savePath = fullfile(pOption.SavePath, "FFT", figName);
                    obj.save_figure(fig, savePath, figure_name);
                end
            end       
        end
        
        function save_figure(obj, retFig, savePath, figName)
            save_figure(retFig, savePath, figName)
        end
        
        
    end
end









