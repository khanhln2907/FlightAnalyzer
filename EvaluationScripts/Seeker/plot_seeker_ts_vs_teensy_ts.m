function plot_seeker_ts_vs_teensy_ts(ax, dataTable)
    diff_cam_T4 = dataTable.TARGET_INFO.TimeCamera - dataTable.TARGET_INFO.TimePacket;
    diff_enc_T4 = dataTable.TARGET_INFO.TimeEncoder - dataTable.TARGET_INFO.TimePacket;
    plot(ax, dataTable.TARGET_INFO.TimePacket / 1e6, diff_cam_T4 / 1e3, '-o', "DisplayName", "\Delta(Cam, T4)");
    hold on; grid on;
    plot(dataTable.TARGET_INFO.TimePacket / 1e6, diff_enc_T4 / 1e3, '-o', "DisplayName", "\Delta(Enc, T4)");
    legend
    title("Difference between MC timestamp and Teensy timestamp");
    xlabel("Time [s]");
    ylabel("\Delta t [ms]");
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end