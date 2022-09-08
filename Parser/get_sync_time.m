%% Since the synch procedure reset the timestamp, one log file might contains multiple intervals that the timestamp overlaps. 
%% This method returns the dataTable that contains only the measurements after the lastest synchronization 
%% 
%% Note: Ideal method should automatically detect the sync and split the dataTable into the corressponding amount of synched dataTable (TODO)
%% At the current stage, this method only get the latest synched portion.

function [out] = get_sync_time(dataTable)
    f = fieldnames(dataTable);
    for i = 1:numel(f)   
        topicTable = dataTable.(f{i});
        try
            timeVector =  topicTable.Time;
            %% Get the latest synch index, where the timestamp reset so the diff < 0
            idSplit = find(diff(timeVector) < 0);    
            latestSynchID = max(idSplit) + 1;
            %% Process the data Vector
            out.(f{i}) = topicTable(latestSynchID:end,:);
        catch ME
            %fprintf('Topic "%s" can not be processed the synch time. Error: %s', f{i}, ME.message);
        end
    end
end

%% Helper function
