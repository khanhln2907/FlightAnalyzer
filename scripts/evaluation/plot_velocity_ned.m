function [out] = plot_velocity_ned(dataVel, ax)

    if ~exist('ax','var')
        figure
        ax = axes();
    end
    
    out.lineGPS(1) = plot(dataVel.VELOCITY_NED.Time / 1e6, dataVel.VELOCITY_NED.VelNorth, '-o', 'DisplayName', 'V_{North} Mes');
    hold on;
    out.lineGPS(2) = plot(dataVel.VELOCITY_NED.Time / 1e6, dataVel.VELOCITY_NED.VelEast, '-o', 'DisplayName', 'V_{East} Mes');
    out.lineGPS(3) = plot(dataVel.VELOCITY_NED.Time / 1e6, dataVel.VELOCITY_NED.VelDown, '-o', 'DisplayName', 'V_{Down} Mes');

    out.linesSP = plot(dataVel.FCON_LOG_SP.Time / 1e6, dataVel.FCON_LOG_SP.VelNorth, '-.', 'DisplayName', 'V_{North} Set', 'Color', out.lineGPS(1).Color);
    out.linesSP = plot(dataVel.FCON_LOG_SP.Time / 1e6, dataVel.FCON_LOG_SP.VelEast, '-.', 'DisplayName', 'V_{East} Set', 'Color', out.lineGPS(2).Color);
    out.linesSP = plot(dataVel.FCON_LOG_SP.Time / 1e6, dataVel.FCON_LOG_SP.VelDown, '-.', 'DisplayName', 'V_{Down} Set', 'Color', out.lineGPS(3).Color);
   
    out.Legend = legend();
    out.XLabel = xlabel('Time [s]');
    out.YLabel = ylabel('Velocity [m/s]');
    grid('on');

    ax = gca;
    ax.FontSize = 20;
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end

