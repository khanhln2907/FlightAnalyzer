% Define some data
[xo,yo] = ndgrid(1:4,1:5);    % data point positions
data = 100*rand(numel(xo),1); % data point values
% Form patch faces, each for each point of the data
width = 0.8;
x = nan(4,numel(xo));
y = nan(4,numel(xo));
x(1,:) = xo(:) - width/2;    y(1,:) = yo(:) - width/2;
x(2,:) = xo(:) - width/2;    y(2,:) = yo(:) + width/2;
x(3,:) = xo(:) + width/2;    y(3,:) = yo(:) + width/2;
x(4,:) = xo(:) + width/2;    y(4,:) = yo(:) - width/2;
% Plot patch objects
hFig = figure('color','w');
hPatch = patch('XData',x, 'YData',y, 'ZData',0*x, 'CData',data, 'FaceColor','flat');
colormap jet; colorbar;
% Store data in patch-userdata
hPatch.UserData.data = data;
% Set buttondownfcn on patch objects.
datacursormode(hFig,'off') %data cursor mode will prevent mouse clicks!
hPatch.ButtonDownFcn = @patchButtonDownFcn;

function patchButtonDownFcn(patchObj, hit)
    % Responds to mouse clicks on patch objs.
    % Add point at click location and adds a datacursor representing
    % the underlying patch.
    % datatip() requires Matlab r2019b or later
    % Find closet vertices to mouse click
    hitPoint = hit.IntersectionPoint;
    [~, minDistIdx] = min(pdist2(patchObj.Vertices,hitPoint));
    % Find patch associated with nearest vertices
    [patchIndex, ~] = find(patchObj.Faces == minDistIdx);
    % store original hold state and return at the end
    ax = ancestor(patchObj,'axes');
    holdStates = ["off","on"];
    holdstate = ishold(ax);
    cleanup = onCleanup(@()hold(holdStates(holdstate+1)));
    hold(ax,'on')
    % Search for and destroy previously existing datatips
    % produced by this callback fuction.
    preexisting = findobj(ax,'Tag','TempDataTipMarker');
    delete(preexisting)
    % detect 2D|3D axes
    nAxes = numel(axis(ax))/2;
    % Plot temp point at click location and add basic datatip
    if nAxes==2  % 2D axes
        hh=plot(ax,hitPoint(1),hitPoint(2),'k.','Tag','TempDataTipMarker');
        dt = datatip(hh, hitPoint(1), hitPoint(2),'Tag','TempDataTipMarker');
    else %3D axes
        hh=plot3(ax,hitPoint(1),hitPoint(2),hitPoint(3),'k.','Tag','TempDataTipMarker');
        dt = datatip(patchObj, hitPoint(1), hitPoint(2), hitPoint(3),'Tag','TempDataTipMarker');
    end
    dt.DeleteFcn = @(~,~)delete(hh);
    clear cleanup % return hold state
    % Update datatip
    pos = hit.IntersectionPoint(1:2);
    dtr = dataTipTextRow('Patch index:', patchIndex, '%i');
    dtr(2) = dataTipTextRow('Data value:', patchObj.UserData.data(patchIndex), '%g');
    hh.DataTipTemplate.DataTipRows(end+1:end+2) = dtr;
end