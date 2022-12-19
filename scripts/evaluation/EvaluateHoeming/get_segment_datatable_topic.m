function [out] = get_segment_datatable_topic(dataTable, t_mins, t_max_s)
    fNames = fieldnames(dataTable);
    for i = 1:numel(fNames)
        try
            out.(fNames{i}) = get_topic_sample_interval(dataTable.(fNames{i}),t_mins, t_max_s);
        catch
            out.(fNames{i}) = dataTable.(fNames{i});
            fprintf("Ignored topic %s of dataTable during data cleaning. \n", fNames{i});
        end
    end
end

