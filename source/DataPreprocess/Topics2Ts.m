function dataTable = Topics2Ts(dataTable, topic, topicType)
    % Convert the given topic and the fieldnames into time series
    
    try 
        % Check if "Timestamp" exist ... 
        % Check if the requested fields exist ...
        
        for i = 1: numel(topicType.DataFields)
            tsInfo = TSInfo(topicType.Source,  topicType.DataFields(i), topicType.Unit, topicType.DataFields(i), topicType.fs);
            fName = sprintf("%s_%s", topicType.Source, topicType.DataFields(i));
            dataTable.(fName) = TimeSeries(dataTable.(topic).Time / 1e6, dataTable.(topic).(topicType.DataFields(i)), tsInfo); %!Todo: check "Time" field
        end        
    catch ME
        fprintf('\n %s \n',ME.message);
    end
end