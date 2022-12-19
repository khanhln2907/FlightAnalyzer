

if(plotInterPolation)
    % Attitude rate
    figname = 'Attitude Rate';
    figure('Tag',figname,'name', figname,'Position', c.Pos_Groesse_SVGA);    
    subplot(311);
    plot(time_Int, p_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAttRate, mesP, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("P [deg/s]");
    title(['P [deg/s]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(312);
    plot(time_Int, q_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAttRate, mesQ, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("Q [deg/s]");
    title(['Q [deg/s]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(313);
    plot(time_Int, r_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAttRate, mesR, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("R [deg/s]");
    title(['R [deg/s]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');
    
    
    % Attitude
    figname = 'Attitude';
    figure('Tag',figname,'name', figname,'Position', c.Pos_Groesse_SVGA);    
    subplot(311);
    plot(time_Int, phi_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAtt, mesPhi, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("\Phi [deg]");
    title(['\Phi [deg]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(312);
    plot(time_Int, theta_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAtt, mesTheta, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("\Theta [deg]");
    title(['\Theta [deg]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(313);
    plot(time_Int, psi_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeAtt, mesPsi, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("\Psi [deg]");
    title(['\Psi [deg]',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    % Velocity
    figname = 'Velocity';
    figure('Tag',figname,'name', figname,'Position', c.Pos_Groesse_SVGA);    
    subplot(311);
    plot(time_Int, velN_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeVel, mesVn, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("V-North [m/s]");
    title(['Velocity North',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(312);
    plot(time_Int, velE_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeVel, mesVe, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("V-East [m/s]");
    title(['Velocity East',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(313);
    plot(time_Int, velD_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeVel, mesVd, '-g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("V-Down [m/s]");
    title(['Velocity Down',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    % OF
    figname2 = 'Optical Flow';
    figure('Tag',figname2,'name', figname2,'Position', c.Pos_Groesse_SVGA);    
    subplot(311);
    plot(time_Int, dx_Int ,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeOF, mesDX, 'Color', 'g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("OF Dx [motions]");
    title(['Optical Flow - X Motions',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(312);
    plot(time_Int, dy_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeOF, mesDY, 'Color', 'g', 'LineWidth', 0.5);                   % Plot of Log
    xlabel("Time [s]");
    ylabel("OF Dy [motions]");
    title(['Optical Flow - Y Motions',newline],'FontWeight','bold','FontSize',c.FS_title);
    legend('Intp','Real');

    subplot(313);
    plot(time_Int, lidar_Int,'-x', 'Color', 'r', 'LineWidth', 0.5);  % Plot of Interpolation
    hold on; grid on;
    plot(timeLidar, mesH, '-g', 'LineWidth', 0.5);                   % Plot of Log
    legend('Intp','Real');
    xlabel("Time [s]");
    ylabel("Altitude [m]");
    title(['Lidar',newline],'FontWeight','bold','FontSize',c.FS_title);
end


