function [Vx, Vy] = ComputeOF2Vb(dxRaw, dyRaw, alt, pRad, qRad, rRad, time)
    % Algorithm Parameter
    formular = 3;   % 1: Geometry 2: Marcus Greiff 
    usingMotionCompensation = true;

    %% Adjust the allignment of the sensor
    % Old version
    % x <-> dy
    % y <-> -dx
    %tmpdxRaw = dxRaw;
    %dxRaw = dyRaw; 
    %dyRaw = -tmpdxRaw;
    
    %% Preprocessing
    %% Compensation for smoothing data and high rates
    if(usingMotionCompensation)
        [dpxClean, dpyClean] = getCompensatedMotion(250, dxRaw, dyRaw, alt, pRad, qRad, rRad);
    else
        dpyClean = dyRaw;
        dpxClean = dxRaw;
    end

    % Plot compensation
    figname = 'OFS Compensation';
    figure('Tag',figname,'name', figname); 
    ax(1) = subplot(211);
    plot(time, dxRaw, '-o', "DisplayName", "Raw");  % Plot of Interpolation
    hold on; grid on;
    plot(time, dpxClean, '-o', "DisplayName", "Compensated");                   % Plot of Log
    xlabel("Time [s]");
    ylabel("Dx compensation", 'FontSize', 24);
    title(['Motion Compensation X and Y',newline],'FontWeight','bold','FontSize',24);

    ax(2) = subplot(212);
    plot(time, dyRaw, '-o', "DisplayName", "Raw");  % Plot of Interpolation
    hold on; grid on;
    plot(time, dpyClean, '-o', "DisplayName", "Compensated");                   % Plot of Log
    xlabel("Time [s]");
    ylabel("Dy compensation");

    legend
    linkaxes(ax, 'x');
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    
    %% Computation of distance moved in a fixed interval
    if(formular == 1) % Website https://ardupilot.org/copter/docs/common-mouse-based-optical-flow-sensor-adns3080.html
        gain = 5;
        dpy = gain * (dpyClean .* alt) / (35 * 35 * 1) * tan(21 * pi / 180);
        dpx = gain * (dpxClean .* alt) / (35 * 35 * 1)  * tan(21 * pi / 180);
    elseif(formular == 3) % My own
        gain = 0.12;
        dpy = gain * alt .* tan(dpyClean * 21/35 * pi / 180);
        dpx = gain * alt .* tan(dpxClean * 21/35 * pi / 180);
    elseif(formular == 2) % Master Thesis of Marcus Greiff
        gain = 0.09;
        dpx = gain * 42 * pi / 180 /35  .* alt .* dpxClean;
        dpy = gain * 42 * pi / 180 /35 .* alt .* dpyClean;

    end
    
    %% POST PROCESSING %%%
    Vx = dpx * 100;
    Vy = dpy * 100;
end

function [dxComp, dyComp] = getCompensatedMotion(gain, dxRaw, dyRaw, alt, pRad, qRad, rRad)
        % Compute Errors of OF measurements due to rotation of axes
        errorDx = gain * qRad;  
        errorDy = -gain * pRad;
       
        % Compute Errors of OF measurements due to rotation of yaw axis
        errorYawScale = 1;

        dxComp = errorYawScale .* (dxRaw - errorDx);
        dyComp = errorYawScale .* (dyRaw - errorDy);
end
