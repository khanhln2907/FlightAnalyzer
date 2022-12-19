function [out] = get_target_info_interval(dataTable, t_min_s, t_max_s)
    out = dataTable.TARGET_INFO((dataTable.TARGET_INFO.TimePacket/1e6 < t_max_s) & (dataTable.TARGET_INFO.TimePacket/1e6 > t_min_s),:);
end

