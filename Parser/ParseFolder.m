function [out] = ParseFolder()
    d = uigetdir(pwd, 'Select a folder');
    files = dir(fullfile(d, '*.TXT'));
    
    path = files.folder;
    
    for i =  1:numel(files.name)
        curFile = fullfile(path, files(i).name);
        try
            JSONParser(curFile);
        catch ME
            fprintf("Parse error %s", ME.message);
        end
    end
end

