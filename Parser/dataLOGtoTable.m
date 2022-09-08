function dataTable = dataLOGtoTable(dataLOG, evaluation)
    % Raise some assertion to ensure the evalution contains the
    % parseFormatStructure and the savePath/ FilePath
    
    parseFormat = evaluation.ParsedFormat;
    fName = fieldnames(dataLOG);
    dataTable = {};
    for formatLine = 1:numel(fName)
        try
            topicsName = parseFormat.(fName{formatLine}).Name;
            if(~isempty(dataLOG.(fName{formatLine}).Data))
                topicsDataStruct = parseFormat.(fName{formatLine}).Data;
                % Assign the value according to the variable name
                for lineNr = 1:numel(topicsDataStruct)
                    cntTotal = size(dataLOG.(fName{formatLine}).Data);
                    Value.(topicsDataStruct{lineNr}) = dataLOG.(fName{formatLine}).Data(1:cntTotal,lineNr);
                end
                dataTable.(topicsName) = struct2table(Value);
                Value = {};
            end
        catch ME
                fprintf("Ignoring fieldname %s in dataLOGtoTable. Error msg: %s \n", fName{formatLine}, ME.message);
        end
    end
    
    dataTable.evaluation = evaluation;
    try
        [dataTable] = Post_Parsing(dataTable);
    catch ME
        fprintf("Post Processing was not performed!, Error: %s", ME.message);
        save(evaluation.dataTableSavePath, "dataTable");
    end
    save(evaluation.dataTableSavePath, "dataTable");
    
end
