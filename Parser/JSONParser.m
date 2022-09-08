function [dataTable] = JSONParser(InputFileName)

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
    
    %% Obtaining the parsing format
    fileHandler = regexp(fileread(filePath),'\n','split');
    fileLen = numel(fileHandler);
    formatStart = find(contains(fileHandler,"LOGGING_FORMAT"));
    formatEnd = find(contains(fileHandler,"END"));
    
    if(numel(formatStart) > 1)
       fprintf("WARNING: Multiple flight tests detected in 1 log file. nTest: %d", numel(formatStart)); 
    end
    
    assert(fileLen > 0);
    assert(formatStart(1) ~= 0); 
    assert(formatEnd(1) ~= 0);
    assert(formatEnd(1) > formatStart(1));
    
    
    parseFormat = {};
    for formatLine = formatStart + 1: formatEnd - 1
        thisLine = fileHandler{formatLine};
        try
            [parsedLine] = JSONDecode(thisLine);
            %assert(isfield(parsedLine,'Format'));
            StructName = fieldnames(parsedLine);
            IDs = fieldnames(parsedLine.(StructName{:}));
            parseFormat.(IDs{:}) = parsedLine.(StructName{:}).(IDs{:});
        catch ME
            fprintf("Format declaration error at line: %s ", thisLine);
        end  
    end
   
        
    assert(~isempty(parseFormat));
    
    %% Start parsing the datalog. WARN: this is the most time consuming part of the parser
    dataLOG = {};

    % Variables used to evaluate logging
    ignoredLineID = zeros(fileLen,1);
    ignoredLineList = string(ignoredLineID);
    ignoredCnt = 0;
    
    TOPIC_SIGNAL_LIST = fieldnames(parseFormat);
    
    %% Big Loops
    totalParsedLineCnt = 0;
    parsedLineNr = [];
    
    tStart = tic;
    [h,m,s] = hms(datetime('now','Format','HH:mm:ss.SSS'));
    fprintf('Start parsing at %02d:%02d:%.1f. Total line: %d \r\n',h,m,s, fileLen);
    for i = 1:numel(TOPIC_SIGNAL_LIST)
        curTopicIDStr = TOPIC_SIGNAL_LIST{i};
        curTopicID = curTopicIDStr(2:end);
        curTopicIDLines = find(contains(fileHandler,sprintf("""%s""", curTopicID)));
        cnt = 0;
        DataMatrix = zeros(numel(curTopicIDLines), numel(parseFormat.(curTopicIDStr).Data));
      
        for topicLineIndex = 1: numel(curTopicIDLines)
            curLineNr = curTopicIDLines(topicLineIndex);
            thisLine = fileHandler{curLineNr};
            [isValid ,~, payload] = ParseLine(thisLine);
            if(isValid)
                try % Some lines are parsewd correctly but the data do not match the declared logging format so we have to handle this error
                    cnt = cnt + 1;
                    DataMatrix(cnt,:) = payload;     
                    totalParsedLineCnt = totalParsedLineCnt + 1;
                catch ME
                    % Save the invalid string for post evaluation
                    fprintf('Line %d Error: %s\n',curLineNr, ME.message);
                    ignoredCnt = ignoredCnt + 1;
                    ignoredLineID(ignoredCnt) = curLineNr;
                    ignoredLineList(ignoredCnt) = thisLine;
                end
            else
                % Save the invalid string for post evaluation
                ignoredCnt = ignoredCnt + 1;
                ignoredLineID(ignoredCnt) = curLineNr;
                ignoredLineList(ignoredCnt) = thisLine;
            end
            
            % Printing to update the process
            if(mod(totalParsedLineCnt, 50000) == 0 && totalParsedLineCnt ~= 0)
                fprintf('Parsed: %d / %d lines. Ignored: %d lines. Time passed: %f \r\n', totalParsedLineCnt, fileLen, ignoredCnt, toc(tStart));
            end
        end
        
        dataLOG.(curTopicIDStr).Name = curTopicIDStr;
        dataLOG.(curTopicIDStr).Data = DataMatrix(~(all(DataMatrix==0,2)),:);
        % Use this variable to save all of the undefined lines into the
        % ignoreList later - Not time critical so ignore warning
        parsedLineNr = [parsedLineNr curTopicIDLines];
    end
    
    tmp = ones(fileLen,1);
    tmp(parsedLineNr) = 0; % only consider the non parsed line
    undefinedLineNr = find(tmp);
    for i = 1 : numel(undefinedLineNr) 
        ignoredCnt = ignoredCnt + 1;
        ignoredLineID(ignoredCnt) = undefinedLineNr(i) ;
        ignoredLineList(ignoredCnt) = fileHandler(undefinedLineNr(i));
    end
    
    
    
    %% Return
    evaluation.ParsedFormat = parseFormat;
    evaluation.ignoreLines = ignoredLineList(ignoredLineList ~= "0");
    evaluation.ignoredLineID = ignoredLineID(ignoredLineID ~= 0);
    evaluation.nIgnoredLines = ignoredCnt;
    evaluation.nTotalLines = fileLen; 
    evaluation.parsedTime = toc(tStart);
    evaluation.FilePath = savePath;
    evaluation.dataTableSavePath = savePath;
        
        %% Post Processing - transform to a dataTable and save to the dataTableSavePath
    try    
        dataTable = dataLOGtoTable(dataLOG, evaluation);

    catch ME
        fprintf("Constructing table from parsed file failed. Error msg: %s \n", ME.message);
        [h,m,s] = hms(datetime('now','Format','HH:mm:ss.SSS'));
        dataLOGsavePath = fullfile(fileDir, sprintf("dataLOG_%s_%d%d", name, h,m));
        fprintf("Save the dataLOG variable for post processing at %s \n", dataLOGsavePath);
        dataLOG.evaluation = evaluation;
        save(dataLOGsavePath, "dataLOG");
    end
    
    fprintf("Finished! Exit ... \n");
end

