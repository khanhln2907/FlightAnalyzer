%% Check the data structure in the preprocessing script
%% 
%%
function [intplData] = get_related_intpl_ofs_sample(data, timeIntpl, method)
    intplData.Time = timeIntpl;
    f = fieldnames(data);
    for i = 1:numel(f)
        intplData.(f{i}) = interpolate_topic_sample(data.(f{i}), intplData.Time, method);
    end
end

