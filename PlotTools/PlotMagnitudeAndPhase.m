function [h] = PlotMagnitudeAndPhase(f, A, P, varargin)
    %function [h] = PlotMagnitudeAndPhase(f, A, P, varargin)
    % f:           Frequency vector
    % A:           Magnitude vector
    % P:           Phase vector
    % Optional parameters:
    % 'minPeakDist:        minimum distance of peaks. Default: 0
    % 'prominence':        Prominence of peaks. Default: rms(A-mean(A))
    % 'FrequencyLabel':    Label for frequency axis. Default: 'Frequency [Hz]'
    % 'MagnitudeLabel':    Label for Magnitude axis. Default: 'Magnitude [Pa]'
    % 'PhaseLabel':        Label for Phase axis. Default: 'Phase [rad]'
    % 'Title':             Title string. Default: empty. If no title is specified, the unused space is used be the
	% 'Marker':            Either 'on' (default) of 'off'
    % Magnitude axis.
    
    p = inputParser;
    addRequired(p, 'f');
    addRequired(p, 'A');
    addRequired(p, 'P');
    addParameter(p, 'minPeakDist', 0, @(x)isnumeric(x));
    addParameter(p, 'prominence', rms(A - mean(A)), @(x)isnumeric(x));
    addParameter(p, 'FrequencyLabel', 'Frequency [Hz]');
    addParameter(p, 'MagnitudeLabel', 'Magnitude [Pa]');
    addParameter(p, 'PhaseLabel', 'Phase [rad]');
    addParameter(p, 'Title', '');
	addParameter(p, 'Marker', 'on');
    
    parse(p,f,A,P, varargin{:});
    
    f = p.Results.f;
    A = p.Results.A;
    P = p.Results.P;
    
    minPeakDist = p.Results.minPeakDist;
    prominence = p.Results.prominence;
    
    h.Figure = figure('Name', 'Magnitude and Phase');
    
    % Prepare subplot
    h.axMag = subplot(2,1,1, 'align');
    hold(h.axMag, 'on');
    h.axPhase = subplot(2,1,2, 'align');
    hold(h.axPhase, 'on');
    box(h.axPhase, 'off');
    box(h.axMag, 'off');
    grid(h.axPhase, 'on');
    grid( h.axMag, 'on');
    
    
    FormatFigureDiss(h.Figure, 8, 8/6, 'MarkerSize', 8);
    
    
    % Calc and plot magnitude data
	if strcmpi(p.Results.Marker, 'on')
    hPaD = PlotPeaksAndData(f, A, minPeakDist, prominence, ...
        'MarkerPosition', 'north', 'PeakMode', 'max', 'ax', h.axMag, 'LabelPeakMode', 'x', 'MarkerStyle', 'v', 'LabelSize', 16);
	else
		hPaD = PlotPeaksAndData(f, A, minPeakDist, prominence, ...
        'MarkerPosition', 'north', 'PeakMode', 'max', 'ax', h.axMag, 'LabelPeakMode', 'none', 'MarkerStyle', 'none');
	end
    
    % Get relevant phase information
    xPhaseLocs = hPaD.Peaks.Locations;
    if ~isempty(hPaD.Peaks.Locations)
    yPhaseLocs = findPhaseAtFrequencies(P, f, xPhaseLocs);
    
    h.Stem = stem(h.axPhase, xPhaseLocs, yPhaseLocs, 'LineWidth', hPaD.Line.LineWidth, 'Color', hPaD.Line.Color);
    
    ylim(h.axPhase, [-pi pi]);
    h.axPhase.YAxis.TickLabelInterpreter = 'latex';
    
    yticks(h.axPhase, [-pi -0.5*pi 0 0.5*pi pi]);
    yticklabels(h.axPhase, {'-\pi', '$-\frac{\pi}{2}$', '$0$', '$+\frac{\pi}{2}$', '+\pi'});
    linkprop([hPaD.Line h.Stem], 'LineWidth');
    end
    

    
    hPaD.Line.Color = [hPaD.Line.Color(1:2) 1];
    h.axMag.XAxisLocation = 'top';
    h.axMag.XAxis.Visible = 'off';
    h.axPhase.XAxisLocation = 'bottom';
    h.axMag.XMinorGrid = 'on';
    h.axMag.YMinorGrid = 'on';
    h.axPhase.XMinorGrid = 'on';
    h.axPhase.YMinorGrid = 'on';
    
    h.axPhase.XLim = h.axMag.XLim;
    
    linkaxes([h.axMag h.axPhase], 'x');
    
    h.MagXLabel = xlabel(h.axMag, p.Results.FrequencyLabel);
    h.PhaseXLabel = xlabel(h.axPhase, p.Results.FrequencyLabel);
    h.MagYLabel = ylabel(h.axMag, p.Results.MagnitudeLabel, 'Units', 'normalized');
    h.PhaseYLabel = ylabel(h.axPhase, p.Results.PhaseLabel, 'Units', 'normalized');
    
    if ~strcmpi(p.Results.Title, '')
        h.Title = title(h.axMag, p.Results.Title, 'Units', 'normalized');
        h.Title.Position = [0.5, 1.02, 0];
     yTop = 0.9; 
    else
        yTop = 0.93;
    end

    
    h.MagYLabel.Position = [-0.08 0.5 0];
    h.PhaseYLabel.Position = [-0.08 0.5 0];
    linkprop([h.MagYLabel h.PhaseYLabel], 'Position');
    
    
    xLeft = 0.12;
    xRight = 0.97;
    yCenter = 0.5;
    yCentDist = 0.04;

    yBottom = 0.15;
    heightTop = yTop - yCenter+yCentDist/2;
    heightBottom = yCenter-yCentDist/2-yBottom;
    width = xRight - xLeft;
    
    % Move axes to better positions...
    h.axMag.Position = [xLeft yCenter+yCentDist/2 width heightTop ];
    h.axPhase.Position = [xLeft yBottom width heightBottom ];
    
    
    %xlim([h.axMag h.axPhase], [0 25]);
    
    FormatFigureDiss(h.Figure, 8, 8/6, 'MarkerSize', 8);
    
end

function PeakPhases = findPhaseAtFrequencies(P, f, fPeaks)
    
    for iPeak = 1:numel(fPeaks)
        PeakPhases(iPeak) = P(f == fPeaks(iPeak));
    end
    
end

