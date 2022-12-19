classdef OFSAnalyzer    
    properties
%         ofsSample
%         attSample
%         attRateSample
%         lidarSample
%         velSample
    end
    
    methods
%         function obj = OFSAnalyzer(ofsSample)
%             obj.ofsSample = ofsSample;
%         end
     
        
        
    end
    
    methods(Static)
        function out = intpl_samples(sampleArr, timeRef)
            out = cell(numel(sampleArr),1);
            for i = 1:numel(sampleArr)
                out{i} = sampleArr{i}.interpolate(timeRef);
            end
        end
        
        function out = get_adv_compensate_ofs(ofsSample, attRateSample, varargin)
            % Use the org data to compute the disturbances
            [compOfs, disturbances] = OFSAnalyzer.get_compensate_ofs(ofsSample, attRateSample, varargin{:});
            % Find the phase lag between the disturbances and the original
            % ofs sample
            lags = OFSAnalyzer.evaluate_rotation_disturbances(ofsSample, disturbances, varargin{:});
            % Advance - compute a phase shifted version of the ofs sample
            shiftOfsSample = copy(ofsSample);
            shiftOfsSample.topic = append(shiftOfsSample.topic, "_shifted");
            shiftOfsSample.data.Dx =  circshift(shiftOfsSample.data.Dx, -lags.x);
            shiftOfsSample.data.Dy =  circshift(shiftOfsSample.data.Dy, -lags.y);
            [compShiftedOfs, ~] = OFSAnalyzer.get_compensate_ofs(shiftOfsSample, attRateSample, varargin{:});
            out = compShiftedOfs;
            % Evaluate the lags again
            lags = OFSAnalyzer.evaluate_rotation_disturbances(shiftOfsSample, disturbances, varargin{:});
            
            % Cross Evaluation of the shifted and non shifted version
            tmp = CrossAnalyzerBase({ofsSample, compShiftedOfs, compOfs});
            tmp.plot_time_domain_single_figure(varargin{:});
            
            pseudoOfsNoiseSample = copy(ofsSample);
            pseudoOfsNoiseSample.data.Dx = disturbances.Dx;
            pseudoOfsNoiseSample.data.Dy = disturbances.Dy;
            pseudoOfsNoiseSample.topic =  append(ofsSample.topic, "_rate_disturbances");
            tmp = CrossAnalyzerBase({ofsSample, shiftOfsSample, pseudoOfsNoiseSample});
            tmp.plot_time_domain_single_figure(varargin{:});
        end
        
        function [ofsCompSample, disturbances] = get_compensate_ofs(ofsSample, attRateSample, varargin)
            ofsSample = ofsSample.outlier();
            out = OFSAnalyzer.intpl_samples({attRateSample}, ofsSample.data.Time);
            
            intplAttRateSample = out{1}; 
            
            % Tuning parameter
            % TODO: Set this as parameters
            gComp = 5;
            % Compensate the motions due to the rotation
            disturbanceDx = gComp * intplAttRateSample.data.q;  
            disturbanceDy = -gComp * intplAttRateSample.data.p;
            
            ofsCompSample = copy(ofsSample);
            ofsCompSample.data.Dx = ofsSample.data.Dx - disturbanceDx;
            ofsCompSample.data.Dy = ofsSample.data.Dy - disturbanceDy;
            ofsCompSample.topic = append(ofsCompSample.topic, "_rate_compensated");
            
            if(nargout > 1)
                disturbances.Dx = disturbanceDx;
                disturbances.Dy = disturbanceDy;
            end
        end
        
        
        function retLag = evaluate_rotation_disturbances(orgOfsSample, disturbances, varargin)
            retLag.x = 0;
            retLag.y = 0;
            
            % Plot the disturbances vs ofs Samples
            pseudoOfsNoiseSample = copy(orgOfsSample);
            pseudoOfsNoiseSample.data.Dx = disturbances.Dx;
            pseudoOfsNoiseSample.data.Dy = disturbances.Dy;
            pseudoOfsNoiseSample.topic =  append(orgOfsSample.topic, "_rate_disturbances");
            tmp = CrossAnalyzerBase({orgOfsSample, pseudoOfsNoiseSample});
            tmp.plot_time_domain_single_figure(varargin{:});
           
            % Plot the cross correlation
            matVer = matlabRelease;
            if(strcmp(matVer.Release,"R2021a"))
                param = ParameterParser.parse(varargin{:});
                timeFilter = (orgOfsSample.data.Time >= param.tMin) & (orgOfsSample.data.Time <= param.tMax);
                figName = sprintf("Cross Correlation OFS Samples vs Rotation Disturbances [%d %d]", round( param.tMin), round( param.tMax));
                
                retFig = figure("Name", figName);
                subplot(1,2,1)
                [c, lags] = xcorr(orgOfsSample.data.Dx(timeFilter), pseudoOfsNoiseSample.data.Dx(timeFilter), 25);
                stem(lags, c);
                xlabel("Lags [Sample]");
                ylabel("Correlation Coefficients Dx");
                [val, arg] = max(c);
                retLag.x = lags(arg);
                legend(sprintf("Max Lags = %d", retLag.x));
                
                subplot(1,2,2);
                [c, lags] = xcorr(orgOfsSample.data.Dy(timeFilter), pseudoOfsNoiseSample.data.Dy(timeFilter), 25);
                stem(lags, c);
                xlabel("Lags [Sample]");
                ylabel("Correlation Coefficients Dy");
                [val, arg] = max(c); 
                retLag.y = lags(arg);
                legend(sprintf("Max Lags = %d", retLag.y));
                
                sgtitle(figName, "FontSize", 30);
                FormatFigure(gcf, 12, 8/6, 'MarkerSize', 3);
                
                if(isstring(param.SavePath))
                    savePath = fullfile(param.SavePath, sprintf("OFS"));
                    save_figure(retFig, savePath, figName);
                end
            end
        end
    end
end

