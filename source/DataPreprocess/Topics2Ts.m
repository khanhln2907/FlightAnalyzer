function out = Topics2Ts(dataTable, topicName, tsFields, topicInfo)
    % Convert the given topic and the fieldnames into time series
    
    try 
        % Check if "Timestamp" exist ... 
        % Check if the requested fields exist ...
        
        out = cell(numel(tsFields), 1);
        
        for i = 1: numel(tsFields)
            tsInfo = TSInfo(topicInfo.Name, topicInfo.Unit, tsFields(i), topicInfo.fs);
            out{i} = TimeSeries(dataTable.(topicName).Time, dataTable.(topicName).(tsFields(i)), tsInfo); %!Todo: check "Time" field
        end        
    catch ME
        fprintf('\n %s \n',ME.message);
    end
end