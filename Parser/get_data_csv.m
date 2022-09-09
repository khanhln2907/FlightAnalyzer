% Get the path
out = get_datatable_multiple_drones();


function [out] = get_datatable_multiple_drones(parentFolder)
    if(~exist('parentFolder', 'Var'))
        parentFolder = uigetdir(pwd, 'Select the parent folder of all tested device');        
        % The folder that contains all topics
    end
    
    fprintf("Constructing dataTable from multiple log files of multiple drones %s \n", parentFolder);
    
    droneDirs = dir(fullfile(parentFolder, "K*"));
    
    % Save the path to return as output
    for droneID = 1:numel(droneDirs)
        logFile = droneDirs(droneID).name;
        dronePath = fullfile(droneDirs(droneID).folder, logFile);
        
        out.drone{droneID}.path = dronePath;
        try
           out.drone{droneID}.report = get_datatable_multiple_flight(dronePath);
        catch            
           fprintf("Failed parsing log folder %s \n", dronePath) 
        end
    end    
    
    out.parentDir = parentFolder;
    fprintf("Finished processing folder %s ...\n", parentFolder);
end

function [out] = get_datatable_multiple_flight(droneDir)
    if(~exist('droneDir', 'Var'))
        droneDir = uigetdir(pwd, 'Select the folder of the tested device');        
        % The folder that contains all topics
    end
    
    fprintf("Constructing dataTable from multiple log files of drone %s \n", droneDir);
    
    flightDirs = dir(fullfile(droneDir, "Processed_*"));
    
    % Save the path to return as output
    for flightID = 1:numel(flightDirs)
        logFile = flightDirs(flightID).name;
        filePath = fullfile(flightDirs(flightID).folder, logFile);
        try
           out.report{flightID} = get_datatable_single(filePath);
        catch            
           fprintf("Failed parsing log folder %s \n", filePath) 
        end
    end    
    out.droneDir = droneDir;
    
    
    fprintf("Finished parsing csv logs in folder %s\n", droneDir);
end


function [out] = get_datatable_single(csvParentDir)
    if(~exist('csvParentDir', 'Var'))
        csvParentDir = uigetdir(pwd, 'Select the parent folder of the CSV file');        
        % The folder that contains all topics
    else
        
    end
    
    csvDir = fullfile(csvParentDir, "CSV");
    if ~exist(csvDir, 'dir')
       error "CSV flight data is not available";
    end
        
    fprintf("Constructing dataTable from CSV files in path %s \n", csvDir);
    
    % Save the path to return as output
    out.directory = csvParentDir;
    out.CSVDir = csvDir;
    
    % List the csv files in the path
    files = dir(fullfile(csvDir, '*.csv'));
    for topicID = 1:numel(files)
        % Get the topic name
        fileName = fullfile(csvDir, files(topicID).name);
        topicName = erase(files(topicID).name, ".csv");

        % Read the data format and construct a dataTable that contain all data
        try
            fid = fopen(fileName);
            varNames = strsplit(fgetl(fid), ',');
            fclose(fid);

            % Read the CSV into data table
            content = csvread(fullfile(csvDir, files(topicID).name), 1,0);

            data_table.(topicName) = array2table(content);
            data_table.(topicName).Properties.VariableNames = varNames;

        catch
            fprintf("Ignore CSV file %s \n", fileName);
        end        
    end

    % Post process the dataTable
    try
        data_table = Post_Parsing(data_table);
    catch ME
        fprintf("Failed post processing dataTable. %s \n", ME.message);
    end

    
    % Save the dataTable to the directory
    outputFolder = fullfile(csvParentDir, "MATLAB");
    if ~exist(outputFolder, 'dir')
       mkdir(outputFolder)
    end
    
    save(fullfile(outputFolder, sprintf("flight_data_parsed_%s", datetime(floor(now),'ConvertFrom','datenum'))), "data_table");
    out.dataTable = data_table;    
    
    
    fprintf("Finished creating data_table from csv folder %s\n", csvDir);
end