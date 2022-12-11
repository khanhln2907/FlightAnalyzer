function [out] = Table2Ts(dataTable)
 fNames = fieldnames(dataTable);
    
    % Process all fieldnames
    for i = 1: numel(fNames)
        f = fNames(i);
        f = f{1};
        try
            % Check if the topic has timestamp (so we transform them to time series)
            if(isTableField(dataTable.(f), "Time"))
               fprintf("Found %s \n", f);
               
               % Get the samples to transform them into timeseries
               samples = fieldnames(dataTable.(f));
                
                
            end
        catch
            
            
        end
        
    end
end

