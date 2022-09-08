function dataTable = QSpyParser(InputFileName)
    format long;
    
    if(~exist('InputFileName', 'Var'))
        %% Select the report file for parsing
        dir = [pwd, ''];
        [file,path] = uigetfile(fullfile(dir,'*.txt*'),'Choose Log File \n');
        if ~file
            fprintf('No Log file selected. Abort ... \n');
            dataTable = 0;
            return;
        else
            filePath = fullfile(path,file);
            name = erase(file,'.txt'); 
            name = erase(name,'.TXT');
        end
    else
       fprintf("Parsing file %s \n", InputFileName);
       [filePath,name,ext] = fileparts(InputFileName);
%        filePath = pwd;
       filePath = fullfile(filePath, [name ext]);
    end
    
    fileDir = fileparts(filePath);
    savePath = fullfile(fileDir, sprintf("Parsed_%s.mat", name));
   
    %% Do not parse file, if a parsed file already exists.
    if(exist(savePath))
        fprintf('Parsed Table already exists. Loading ... \n');
        load(savePath, 'dataTable');
        return;
    end
    
    %% Read the file handles
    fileHandler = regexp(fileread(filePath),'\n','split');
    fileLen = numel(fileHandler);
    
    %% Obtaining the parsing format
    formatStart = find(contains(fileHandler,"LOGGING_FORMAT"));
    formatEnd = find(contains(fileHandler,"END"));
    
    if(numel(formatStart) > 1)
       fprintf("WARNING: Multiple flight tests detected in 1 log file. nTest: %d", numel(formatStart)); 
    end
    
%     assert(fileLen > 0);
%     assert(formatStart(1) ~= 0); 
%     assert(formatEnd(1) ~= 0);
%     assert(formatEnd(1) > formatStart(1));
    
    %% Read the file handles
    timestampArr = parse_data_acquisition(fileHandler);
    
    
    
    dataTable = timestampArr;
end



function timestampArr = parse_data_acquisition(fileHandler)

    pattern = "USER+007";
    nLines = numel(fileHandler);
    
    idArr = find(contains(fileHandler,pattern));
    nLogged = numel(idArr);
    
    timestampArr = zeros(nLogged, 1);
    
    for i = 1: nLogged
        lineId = idArr(i);
        str = fileHandler{lineId};
        try 
            if(contains(str,pattern))
                tokens = split(str,' ');
                timestampArr(i) = str2num(tokens{1});
            end        
        catch ME
            fprintf("%s \n", ME.message);
        end
    end

end