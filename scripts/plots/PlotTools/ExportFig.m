function  ExportFig( Fig, FileName, isExportPng, isExportSvg, isExportFig, isOverwrite  )
    %function  ExportFig( Fig, FileName, isExportPng, isExportSvg, isExportFig, isOverwrite  )
    
    if nargin < 6
        isOverwrite = false;
    end
    
    if nargin < 5
        isExportFig = false;
    end
    
    if nargin < 4
        isExportSvg = true;
    end
    
    if nargin < 3
        isExportPng = true;
    end
    
    outfiles = {};
    
    if isExportPng
        outfiles{length(outfiles)+1} = strcat(FileName, '.png');
    end
    
    if isExportSvg
        outfiles{length(outfiles)+1} = strcat(FileName, '.svg');
    end
    
    if isExportFig
        outfiles{length(outfiles)+1} = strcat(FileName, '.fig');
    end
    
    [dir, ~, ~] = fileparts(FileName);
    
    if ~(exist(dir, 'dir')== 7)
        if ~isempty(dir)
            mkdir(dir);
        end
    end
    
    for FilePath = outfiles
        Path = char(FilePath);
        [~,~, Suffix] = fileparts(Path);
        if ~exist(Path, 'file') > 0 || isOverwrite
            saveas(Fig, Path);
        end
    end
    
end

