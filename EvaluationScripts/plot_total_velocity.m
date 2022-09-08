function [out] = plot_total_velocity(dataVel, ax)
    
    if ~exist('ax','var')
        figure
        ax = axes();
    end
    
    sumV = sqrt(dataVel.VELOCITY_NED.VelNorth.^2 + dataVel.VELOCITY_NED.VelEast.^2 + dataVel.VELOCITY_NED.VelDown.^2);
    out.hLine = plot(dataVel.VELOCITY_NED.Time / 1e6, sumV, '-o', 'DisplayName', 'V total');
    
    out.Legend = legend();
    out.XLabel = xlabel('Time [s]');
    out.YLabel = ylabel('Velocity [m/s]');
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end

