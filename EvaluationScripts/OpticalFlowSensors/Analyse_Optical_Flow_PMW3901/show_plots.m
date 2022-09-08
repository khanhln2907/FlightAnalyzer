function show_plots(data)
    %% Plot Attitude Rates
    figname = "AttitudeAndRate";
    axAtt = figure('Tag',figname,'name', figname);
    ax(1) = subplot(211);
    plot(data.ATTITUDE_RATE.Time / 1e6, data.ATTITUDE_RATE.p, '-o');
    hold on; grid on; grid minor;
    plot(data.ATTITUDE_RATE.Time / 1e6, data.ATTITUDE_RATE.q, '-o');
    plot(data.ATTITUDE_RATE.Time / 1e6, data.ATTITUDE_RATE.r, '-o');
    ylabel("Rate [Deg/s]");
    legend(["p", "q", "r"]);

    ax(2) = subplot(212);
    plot(data.ATTITUDE.Time / 1e6, data.ATTITUDE.Phi, '-o');
    hold on; grid on; grid minor;
    plot(data.ATTITUDE.Time / 1e6, data.ATTITUDE.Theta, '-o');
    ylabel("Attitude [Deg]");

    yyaxis right;
    plot(data.ATTITUDE.Time / 1e6, data.ATTITUDE.Psi, '-o');
    ylabel("Heading [Deg]");
    xlabel("Time [s]");
    legend(["Phi", "Theta", "Psi"]);

    sgt = sgtitle(['Attitude And Rates',newline]);
    sgt.FontSize = 20;
    linkaxes(ax,'x');
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);

    %% Plot Raw Motions
    figname = 'Motions Optical Flow';
    axMotions = figure('Tag',figname,'name', figname);    
    ax(1) = subplot(211);
    plot(data.OFS_THRONE.Time / 1e6, data.OFS_THRONE.Dx, '-o',"DisplayName", "Throne");  % Plot of Interpolation
    hold on; grid on; grid minor;
    plot(data.OFS_PMW3901.Time / 1e6, data.OFS_PMW3901.Dx, '-o', "DisplayName", "PMW3901");  % Plot of Interpolation
    ylabel("Motions X");

    ax(2) = subplot(212);
    plot(data.OFS_THRONE.Time / 1e6, data.OFS_THRONE.Dy, '-o',"DisplayName", "Throne");  % Plot of Interpolation
    hold on; grid on; grid minor;
    plot(data.OFS_PMW3901.Time / 1e6, data.OFS_PMW3901.Dy, '-o', "DisplayName", "PMW3901");  % Plot of Interpolation
    xlabel("Time [s]");
    ylabel("Motions Y");
    sgt = sgtitle(['Motions X and Y',newline]);
    sgt.FontSize = 20;
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    linkaxes(ax,'x');
    legend;

    

%% END
