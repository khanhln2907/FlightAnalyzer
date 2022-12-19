function out = interpolate_topic_sample(topicTable, timeIntpl, type)
    f = topicTable.Properties.VariableNames;
    out.Time = timeIntpl;
    for i = 1:numel(f)
       if(f{i} ~= "Count" && (f{i} ~= "Time") && (f{i} ~= "State"))
           out.(f{i}) = interp1(topicTable.Time, topicTable.(f{i}), out.Time, type);
       end
    end
    out = struct2table(out);
end