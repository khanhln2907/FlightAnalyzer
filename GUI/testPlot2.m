t = 1:0.01:10;
x = sin(2 * pi * 1/10 * t);
y = 1000 * cos(2 * pi * 5/10 * t);

ax(1) = plot(t, x);
hold on;

yyaxis right
ax(2) = plot(t, y);

grid on; grid minor;

%%
% Create two identical overlaying axes
fig = figure();
ax1 = axes(); 
ax2 = copyobj(ax1, fig); 
% Link the x axes
linkaxes([ax1,ax2],'x')
% Choose colors for the 2 y axes.
axColors = [
    0        0.39063   0;        % dark green
    0.53906  0.16797   0.88281]; % blue violet
% Do plotting (we'll adjust the axes and the ticks later)
plot(ax1, 1:100, sort(randn(1,100)*100), '-', 'Color', axColors(1,:)); 
plot(ax2, 1:100, sort(randn(1,100)*60), '-', 'Color', axColors(2,:));
% Set axes background color to transparent and turns box on
set([ax1,ax2],'Color', 'None', 'Box', 'on')
% Set y-ax to right side
set([ax1,ax2], 'YAxisLocation', 'right')
% make the axes 10% more narrow
set([ax1,ax2], 'Position', ax1.Position .* [1 1 .90 1]) 
% set the y-axis colors
ax1.YAxis.Color = axColors(1,:); 
ax2.YAxis.Color = axColors(2,:); 
% After plotting set the axis limits. 
ylim(ax1, ylim(ax1)); 
ylim(ax2, ylim(ax2)); 
% Set the y-ticks of ax1 so they align with yticks of ax2
% This also rounds the ax1 ticks to the nearest tenth. 
ax1.YTick = round(linspace(min(ax1.YTick),max(ax1.YTick),numel(ax2.YTick)),1); 
    % Extend the ax1 y-ax ticklabels rightward a bit by adding space
    % to the left of the label.  YTick should be set first. 
    ax1.YTickLabel = strcat({'          '},ax1.YTickLabel);
% Set y-ax labels and adjust their position (5% inward)
ylabel(ax1,'y axis 1')
ylabel(ax2','y axis 2')
ax1.YLabel.Position(1) = ax1.YLabel.Position(1) - (ax1.YLabel.Position(1)*.05); 
ax2.YLabel.Position(1) = ax2.YLabel.Position(1) - (ax2.YLabel.Position(1)*.05); 

%%
x=0:0.5:10;
y1=0.1*sin(0.1*x);
y2=0.1*cos(0.1*x);
y3=0.1*cos(0.2*x);
%--------------------------------------------------------------------
xlab='time'               % x-axis title
pas=8;           % Number of ticks per axe
tail=8;             % font size
%----------------markers and color/graph----------------------------------
mark1='d',
c1='k'
mark2='<',
c2='b'
mark3='s',
c3='r'
%---------font name and size---------------------------------------------
fontname='courrier'
fontsize=9.2;
fontsize_ax=8;
% -----------your legend names--------------------------------------------
param1='leg1',
param2='leg2',
param3='leg3',
%-----------------y-axis titles----------------------------------------
paramm1='y1',
paramm2='y2',
paramm3='y3',
%----------------------------------------------plot y1---------------------
plot(x,y1,c1)
ax1=gca;
set(gcf,'position',[100 100 1300 550])
line(x,y1,'color',c1,'Marker',mark1,'LineStyle','none','Markersize',tail,'parent',ax1);
set(ax1,'Ylim',[min(y1) max(y1)],'Xlim',[0 max(x)]);
ylabel(paramm1)
xlabel(xlab)
set(ax1,'position',[0.16 0.11 0.73 0.8],'fontsize',fontsize_ax,'Ycolor',c1)
pos=double(get(ax1,'position'))
%----------------------------------------------plot y2---------------------
ax2=axes('position',pos, 'XAxisLocation','bottom','YAxisLocation','left', 'Color','none',  'XColor',c2,'YColor',c2);
plot(x,y2,c2);
line(x,y2,'color',c2,'Marker',mark2,'LineStyle','none','Markersize',tail,'parent',ax2);
set(ax2,'Ylim',[min(y2) max(y2)],'Xlim',[0 max(x)],'Visible','off')
%----------------------------------------------plot y3---------------------
axe3=axes('position',pos, 'XAxisLocation','bottom','YAxisLocation','left','Color','none', 'XColor',c2,'YColor',c2);
plot(x,y3,c3);
line(x,y3,'color',c3,'Marker',mark3,'LineStyle','none','Markersize',tail,'parent',axe3);
set(axe3,'Ylim',[min(y3) max(y3)],'Xlim',[0 max(x)],'Visible','off')
%---------------------------------------------------------ax12-------------
pos12=[0.11 pos(2) 0.001 pos(4)]
axe12=axes('position',pos12,'XAxisLocation','top','YAxisLocation','right',...
  'Color','none','fontsize',fontsize_ax, 'XColor',c2,'YColor',c2);
set(get(axe12,'XLabel'),'String',strvcat(' ',paramm2),'Fontname',fontname,'Fontsize',fontsize);
set(axe12,'Ylim',[min(y2) max(y2)])
inc2=abs(max(y2)-min(y2))/pas;
my=min(y2):inc2:max(y2);
set(axe12,'Ytick',my)
%---------------------------------------------------------ax13-------------
pos13=[0.07 pos(2) 0.001 pos(4)]
axe13=axes('position',pos13, 'XAxisLocation','top','YAxisLocation','right',...
  'Color','none','fontsize',fontsize_ax, 'XColor',c3,'YColor',c3);
set(get(axe13,'XLabel'),'String',strvcat(' ',paramm3),'Fontname',fontname,'Fontsize',fontsize)
set(axe13,'Ylim',[min(y3)   max(y3)])
inc3=(max(y3)-min(y3))/pas;
my=min(y3):inc3:max(y3);
set(axe13,'Ytick',my)
%------------------------------------------------legend-------------------
ax20=axes('position',pos, 'Color','none')
line(-100,100,'color',c1,'Marker',mark1,'LineStyle','-','markerfacecolor',c1,'Markersize',tail,'parent',ax20);
hold on;line(-100,100,'color',c2,'Marker',mark2,'LineStyle','-','markerfacecolor',c2,'Markersize',tail,'parent',ax20);
hold on;line(-100,100,'color',c3,'Marker',mark3,'LineStyle','-','markerfacecolor',c3,'Markersize',tail,'parent',ax20);
set(ax20,'Xlim',[0 1]);
set(ax20,'visible','off');
grid(ax1);
name={param1;param2;param3}
hleg=legend(ax20,name)
title(ax1,'figure1')

%%
% Create some data to work with
x = 0:.1:3; 
y1 = exp(x); 
y2 = log(x); 
y3 = x.^2; 
% create the first axes with the two y axes
figure
yyh = plotyy(x,y1,x,y2);   %see [1]
yyh(1).XTickMode = 'manual'; 
yyh(1).YTickMode = 'manual'; 
yyh(1).YLim = [min(yyh(1).YTick), max(yyh(1).YTick)];  % see [4]
yyh(1).XLimMode = 'manual'; 
grid(yyh(1),'on')
ytick = yyh(1).YTick;  
% create 2nd, transparent axes
ax2 = axes('position', yyh(1).Position);
plot(ax2,x,y3, 'k')
pause(0.1)                 % see [3]
ax2.Color = 'none'; 
grid(ax2, 'on')
% Horizontally scale the y axis to alight the grid (again, be careful!)
ax2.XLim = yyh(1).XLim; 
ax2.XTick = yyh(1).XTick; 
ax2.YLimMode = 'manual'; 
yl = ax2.YLim; 
ax2.YTick = linspace(yl(1), yl(2), length(ytick));      % see [2]
% horzontally offset y tick labels
ax2.YTickLabel = strcat(ax2.YTickLabel, {'       '});