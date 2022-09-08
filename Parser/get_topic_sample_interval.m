function [out] = get_topic_sample_interval(topicTable, tMin_s, tMax_s)
    % out = topicTable((topicTable.Time/1e6 < t_max_s) & (topicTable.Time/1e6 > t_min_s) & (topicTable.State == 3),:);
    out = topicTable((topicTable.Time/1e6 < tMax_s) & (topicTable.Time/1e6 > tMin_s),:);
     [C,ia,ic] = unique(out.Time,'rows');
    out = out(ia,:);
end
