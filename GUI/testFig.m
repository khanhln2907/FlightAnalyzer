fig = figure;

t = 1:10;
x = t.^2;
y = t.^3;

ax(1) = axes();
ax(2) = copyobj(ax(1), fig);

line(1) = plot(ax(1), t, x, '-b');
hold on;

line(2) = plot(ax(2), t, y, '-r');

linkaxes(ax, 'x');
set(ax(2), 'Color', 'None');
set(ax, 'HandleVisibility', 'on');

%set(fig,'ButtonDownFcn',@(~,~)disp('figure'),...
%   'HitTest','on')
set(ax,'ButtonDownFcn',@(~,~)disp('axes'),...
   'HitTest','on')
set(line,'ButtonDownFcn',@(~,~)disp('line'),...
   'HitTest','on')

dcm = datacursormode(gcf);
