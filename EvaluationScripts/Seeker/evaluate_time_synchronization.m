function [dataTable] = evaluate_time_synchronization(dataTable, freq_hb)
    %% Evaluation Heart Beat Message
    % Since the MC message has no checksum, we parse the ignored lines in
    % the parsed file to obtain the heart beat time stamp
    if(~isfield(dataTable,'TIME_HEART_BEAT'))
        dataTable = parse_error_log(dataTable);
    end
    if(~exist("freq_hb", "var"))
        freq_hb = 4; % frequency of heart beat
    end
    
    % compute the time difference between heart beat
    dt_heart_beat_s = diff(dataTable.TIME_HEART_BEAT) / 1e6;
    % ignore the non-positive time step
    dt_heart_beat_filtered_s = dt_heart_beat_s(dt_heart_beat_s > 0);
    
    % get the overall operation time
    time_filtered_s = dataTable.TIME_HEART_BEAT(dt_heart_beat_s > 0) / 1e6;
    time_interval_s = time_filtered_s(end) - time_filtered_s(1);
    % compute the expected heart beat with a fix frequency vs the logged
    % heart beat
    n_heartbeat_should = time_interval_s * freq_hb;
    n_heartbeat_ist = numel(dt_heart_beat_filtered_s);
    fprintf("Heart Beat should be received with a frequency of %d Hz: %f. Heartbeat received: %d \n", freq_hb, n_heartbeat_should, n_heartbeat_ist);

    %% Evaluation Target Info Message
    diff_target_msg = diff(dataTable.TARGET_INFO.TimePacket) / 1e6;
    ti_freq = 1 ./ mean(diff_target_msg);
    fprintf("Frequency of target info message:  %f Hz \n", ti_freq);

        
    %% Visualization
    figure
    subplot(211)
    plot(dataTable.TARGET_INFO.TimePacket(1:end-1) / 1e6, 1 ./diff_target_msg , '--', "DisplayName", "Frequency target info");
    hold on; grid on;
    legend
    title("Difference between timestamp in ms");
    %xlabel("Time [s]");
    ylabel("Frequency");
    
    
    subplot(212)
    plot(time_filtered_s, dt_heart_beat_filtered_s, "DisplayName", "\Delta t  Heart Beat");
    legend
    title("Timestamp of T4 for Heart Beat MC - Manual Log Error Outlier");
    xlabel("Time [s]");
    ylabel("Time [s]");
    
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end

