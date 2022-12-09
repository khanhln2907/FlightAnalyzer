classdef Parser
    %PARAMETERPARSER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        DEFAULT_FOLDER = fullfile(pwd, sprintf("autofig"));
    end
    
    methods (Static)
        function [out] = get_time_param(varargin)
           p = inputParser;
           addParameter(p, 'TimeInterval', [-inf, inf], @(x)isnumeric(x) & (numel(x) == 2));
           parse(p, varargin{:}); 
           out.tMin = p.Results.TimeInterval(1);
           out.tMax = p.Results.TimeInterval(2);
        end
        
        
        function [path] = get_save_path_param(varargin)
           p = inputParser;
           addParameter(p, 'SavePath', Parser.TEMP_FOLDER , @(x) exist(x, 'dir') ~= 0); % if failed, the path does not exist
           parse(p, varargin{:}); 
           path = p.Results.SavePath;
           if(~exist(path, 'dir'))
              mkdir(ParameterParser.TEMP_FOLDER); 
           end
           out.SavePath = path;
        end
        
        function [out] = parse(varargin)
           p = inputParser;
           addParameter(p, 'TimeInterval', [-inf, inf], @(x)isnumeric(x) & (numel(x) == 2));
           addParameter(p, 'SavePath', false , @(x) exist(x, 'dir') ~= 0); % if failed, the path does not exist
           parse(p, varargin{:}); 
           out.tMin = p.Results.TimeInterval(1);
           out.tMax = p.Results.TimeInterval(2);
           out.SavePath = p.Results.SavePath;
        end
        
    end
end

