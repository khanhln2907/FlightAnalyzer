function dt = generateDataTip(ax, xClicked)
    % Find the "line" object in the current 
    axLine =  findall(ax,'type','line', 'tag', '');
    [~, minDistIdx] = min((axLine.XData - xClicked).^2);

    holdStates = ["off","on"];
    holdstate = ishold(ax);
    cleanup = onCleanup(@()hold(holdStates(holdstate+1)));
    hold(ax,'on')

    % Search for and destroy previously existing datatips
    % produced by this callback fuction.
    %preexisting = findobj(ax,'Tag','TempDataTipMarker');
    %delete(preexisting)

    % Plot temp point at click location and add basic datatip
    x = axLine.XData(minDistIdx);
    y = axLine.YData(minDistIdx);

    % Create the DataTip
    verGeq2019 = isGEQRelease('2019b');
    
    if(verGeq2019)
        hh=plot(ax,x, y,'k.','Tag','TempDataTipMarker', 'HandleVisibility','off', "DisplayName", "None");
        dt = datatip(hh, x, y,'Tag','TempDataTipMarker');
        % Update datatip
        hh.DataTipTemplate.DataTipRows(end+1) = ax.YLabel.String;
        dt.DeleteFcn = @(~,~)delete(hh);
    else
        plot(ax, x, y, "*", "MarkerSize", 8, 'HandleVisibility','off', 'Tag', 'TempDataTipMarker', 'LineWidth', 2, "Color", axLine.Color);
        output_txt = sprintf("%.3f\n%.3f", x, y);
        dt = text(ax, x, y, output_txt, 'Color', "black",'FontSize',14, 'Tag', 'TempDataTipMarker');
    end
    
    clear cleanup % return hold state
end

function output_txt = customDatatipFunction(~,evt)
    pos = get(evt,'Position');
    idx = get(evt,'DataIndex');
    output_txt = { ...
        '*** !! Event !! ***' , ...
        ['at Time : '  num2str(pos(1),4)] ...
        ['Value: '   , num2str(pos(2),8)] ...
        ['Data index: ',num2str(idx)] ...
                };
end

