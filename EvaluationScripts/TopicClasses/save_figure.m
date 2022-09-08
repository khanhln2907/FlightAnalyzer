function save_figure(retFig, savePath, figName)
    if(~exist(savePath, 'dir'))
        mkdir(savePath)
    end
    retFig.WindowState = 'maximized';
    saveas(retFig,fullfile(savePath, sprintf('%s.png', figName(1:min(numel(figName),250)))));
    saveas(retFig,fullfile(savePath, sprintf('%s.fig', figName(1:min(numel(figName),250)))));