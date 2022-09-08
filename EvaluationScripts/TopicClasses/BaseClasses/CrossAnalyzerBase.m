classdef CrossAnalyzerBase
    %CROSSANALYZERBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nTopic
        handle
        structInfo
    end
    
    methods
        function obj = CrossAnalyzerBase(sampleHandleArr)
            obj.nTopic = numel(sampleHandleArr);
            obj.handle = sampleHandleArr;
            
            for i = 1:obj.nTopic-1
                % Only 2 samples with the same structure can be cross
                % analyzed
                if(~isequaln(sampleHandleArr{i}.get_analyzed_fieldname(),sampleHandleArr{i+1}.get_analyzed_fieldname()))
                    error ("Different cross elements to be analyzed")
                end
            end
            [obj.structInfo] = sampleHandleArr{1}.get_analyzed_fieldname();
        end
        
        function retFig = plot_time_domain_single_figure(obj, varargin) 
            param = ParameterParser.parse(varargin{:});
            dataHandle = cell(obj.nTopic, 1);
            titleName = sprintf("Cross_Evaluation_[%ds_%ds]", round(param.tMin), round(param.tMax));
            figName = sprintf('%s_', titleName);
            for i = 1:obj.nTopic
                samples = obj.handle{i}.get_data_cross_analyzed(varargin{:});
                dataHandle{i} = samples;
                figName = sprintf("%s__%s", figName, dataHandle{i}.topic);
            end
            
            retFig = figure("Name", figName);
            for dataAx = 1:numel(obj.structInfo.fName)
                ax(dataAx) = subplot(numel(obj.structInfo.fName), 1, dataAx);
                for topic = 1:obj.nTopic
                    line = plot(dataHandle{topic}.data.Time, dataHandle{topic}.data.(obj.structInfo.fName(dataAx)), '-o', "DisplayName", dataHandle{topic}.topic);
                    hold on;
                    ylabel(sprintf("%s [%s]", obj.structInfo.fName(dataAx), obj.structInfo.unit));
                end
            end
            xlabel("Time [s]");
            linkaxes(ax, "x");
            FormatFigure(gcf, 12, 8/6, 'MarkerSize', 3);
            legend('Location', 'Best', "Interpreter", "None");
            title(titleName, "Interpreter", "None");
            if(isstring(param.SavePath))
                savePath = fullfile(param.SavePath, sprintf('Cross_Evaluation_%s', obj.structInfo.datatype));
                save_figure(retFig, savePath, figName);
            end
        end
        
        function retFig = plot_time_domain_multi_figure(obj, varargin)    
            param = ParameterParser.parse(varargin{:});
            dataHandle = cell(obj.nTopic, 1);
            figName = sprintf("Cross_Evaluation_[%ds_%ds]_", round(param.tMin), round(param.tMax));
            for i = 1:obj.nTopic
                dataHandle{i} = obj.handle{i}.get_data_cross_analyzed(varargin{:});
                figName = sprintf("%s__%s", figName, dataHandle{i}.topic);
            end
            
            for i = 1:numel(obj.structInfo.fName)
                retFig = figure("Name", figName);
                for topic = 1:obj.nTopic
                    line = plot(dataHandle{topic}.data.Time, dataHandle{topic}.data.(obj.structInfo.fName(i)), '-o', "DisplayName", dataHandle{topic}.topic);
                    hold on;
                end
                xlabel("Time [s]");
                legend('Location', 'Best', "Interpreter", "None");
                ylabel(sprintf("%s [%s]", obj.structInfo.interpreterName(i), obj.structInfo.unit));                
                FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2.5);
                title(obj.structInfo.datatype, "Interpreter", "None");
                if(isstring(param.SavePath))
                    savePath = fullfile(param.SavePath, sprintf("Cross_Evaluation_%s", obj.structInfo.datatype));
                    save_figure(retFig, savePath, sprintf('%s_%s', figName, obj.structInfo.fName(i)));
                end
            end
        end
        
        function save_figure(obj, retFig, savePath, figName)
            if(~exist(savePath, 'dir'))
                mkdir(savePath)
            end
            retFig.WindowState = 'maximized';
            saveas(retFig,fullfile(savePath, sprintf('%s.png', figName)));
            saveas(retFig,fullfile(savePath, sprintf('%s.fig', figName)));
        end
        
%         function get_lags(data_1, data_2)
%             
%             
%         end
        
    end
end

