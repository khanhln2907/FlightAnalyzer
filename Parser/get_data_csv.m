% Get the path
csvFolder = get_datatable_single();

% List the csv files in the path
files = dir(fullfile(csvFolder, '*.csv'));

for topicID = 1:numel(files)
    % Get the topic name
    fileName = fullfile(csvFolder, files(topicID).name);
    topicName = erase(files(topicID).name, ".csv");
    
    % Read the data format
    try
        fid = fopen(fileName);
        varNames = strsplit(fgetl(fid), ',');
        fclose(fid);

        % Read the CSV into data table
        content = csvread(fullfile(csvFolder, files(topicID).name), 1,0);

        dataTable.(topicName) = array2table(content);
        dataTable.(topicName).Properties.VariableNames = varNames;
    catch
        fprintf("Ignore CSV file %s \n", fileName);
    end
        
end



function [out] = get_datatable_single(csvFolder)
    if(~exist('csvFolder', 'Var'))
        d = uigetdir(pwd, 'Select the parent folder of the CSV file');        
        % The folder that contains all topics
        csvFolder = fullfile(d, "CSV");
    end
    
    disp(csvFolder);
    
    out = csvFolder;
end