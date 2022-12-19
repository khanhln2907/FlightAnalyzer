%% Evaluate logged data

% cd 'H:\PROJEKTE\KF048\Parsing\';
close all;
clear;

addpath([pwd,'\GeodeticToolbox']);  % Hinzufuegen der Toolbox GeodeticToolbox
addpath([pwd,'\PlotTools']);        % Hinzufuegen der Toolbox PlotTools (hier liegen auch die Konstanten)


%% Control outlier removal
options.removeOUT = true;
options.filePicker = true;
options.fullfile = '';

%% Preprocess data

% Check for Matlab version
v = ver('MATLAB');

%% Parsing with old protocols
%[dataLOG, options] = preLOG_2020(options);
%[dataLOG, options] = preLOG_2020_monotime(options);

%% Parsing with JSON protocol
[parsedDataTable, savePath] = JSONParser();
%% Post Processing
fprintf("Execute post processing of the parsed log...\n")

for i = 1: numel(parsedDataTable)
    [dataTable] = Post_Parsing(parsedDataTable{i});  
    %% Save overwrite
    save(savePath{i}, "dataTable");    
end







