function [out] = plot_acceleration(dataAcc, ax)
    if ~exist('ax','var')
        figure
    end
    
    ax(1) = subplot(311);
    out.lineAcc(1) = plot(ax(1), dataAcc.ACCELERATION.Time / 1e6, dataAcc.ACCELERATION.Ax, '-o', 'DisplayName', 'A_x Mes');
    ylabel('a_x [m/s^2]');
    legend()    

    ax(2) = subplot(312);
    out.lineAcc(2) = plot(ax(2), dataAcc.ACCELERATION.Time / 1e6, dataAcc.ACCELERATION.Ay, '-o', 'DisplayName', 'A_y Mes');
    ylabel('a_y [m/s^2]');
    legend()
    
    ax(3) =  subplot(313);
    out.lineAcc(3) = plot(ax(3), dataAcc.ACCELERATION.Time / 1e6, dataAcc.ACCELERATION.Az, '-o', 'DisplayName', 'A_z Mes');
    ylabel('a_z [m/s^2]');
    legend()
    
    linkaxes(ax, 'y');
    linkaxes(ax, 'x');

    
    h=findobj(gcf,'type','axes')
    set([h.XLabel],'string','Time [s]')
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
end

