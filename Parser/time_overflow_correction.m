function [dataTable] = time_overflow_correction(dataTable)
    %format intmax('uint64');

    field_name = fieldnames(dataTable);
    for i = 1: numel(field_name)
        % get the topic
        topic_name = field_name{i};
        topic = dataTable.(topic_name);

        % Only correct the overflow if there is the "Count" field 
        has_count = any(strcmp('Count',fieldnames(topic)));
        has_time = any(strcmp('Time',fieldnames(topic)));
        is_correctable = has_count && has_time;
        if(is_correctable)
            dt = diff(topic.Time);
            dcount = diff(topic.Count);
            id = find(dt < 0);
            
            for j = 1: numel(id)
                ovf_index = id(j);
                if(dcount(ovf_index) < 0)
                    error("Two log file in the same parsed file");
                else
                    ref_time = topic(ovf_index);
                end
            end
        end
        
        % check the counter and the time to detect time overflow
        
    end
end

