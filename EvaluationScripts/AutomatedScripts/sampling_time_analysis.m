function sampling_time_analysis()
    global data;

    fNames = fieldnames(data.dataTable);
    N = numel(fNames);
    L=ceil(N^.5);    
    subplotcnt = 0;

    figure
    for i = 1:numel(fNames)
        try 
            subplotcnt = subplotcnt + 1;
            subplot(L,L,subplotcnt);
            dt_ms = diff(data.dataTable.(fNames{i}).Time) / 1e3;
            histogram(dt_ms, 200);
            xlabel("dt [ms]");
            ylabel("Counts");
            xlim([min(dt_ms), max(dt_ms)]);
            title(sprintf("%s",fNames{i}), "Interpreter", "None");
            grid on; grid minor; 
        catch
            subplotcnt = subplotcnt - 1;
            fprintf("Ignored Topic Sample %s \n", fNames{i});
        end
    end
end




