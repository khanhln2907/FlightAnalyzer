function [dataTable] = parse_error_log(dataTable)
    format long;
    uiSelected = false;

    if(~exist('dataTable', 'Var'))
        %% Select the report file for parsing
        dir = [pwd, ''];
        [file,path] = uigetfile(fullfile(dir,'*.m*'),'Choose Log File \n');
        if ~file
            fprintf('No Log file selected. Abort ... \n');
            dataTable = 0;
            return;
        else
            uiSelected = true;
            load(fullfile(path, file), 'dataTable');
        end
    end
    
    
    %%
    n = numel(dataTable.evaluation.ignoreLines);
    cnt = 1;
    time_mc = zeros(n, 1);
    for i = 1:n
        str = dataTable.evaluation.ignoreLines(i);
        try
            if(contains(str,'"MC":['))
                sub_str = str{1}(7:end-1);
                split_str = split(sub_str,',');
                if(str2double(split_str{2}) == 162)
                    time_mc(cnt) = str2double(split_str{1});
                    cnt = cnt + 1;
                end
            end
        catch
            fprintf("Parse error: %s", str);
        end
    end
    dataTable.TIME_HEART_BEAT =  time_mc(time_mc ~= 0);
    if(uiSelected)
        fprintf("Saved post processing parsed file into %s", fullfile(path, file));
        save(fullfile(path, file), "dataTable");
    end
end

