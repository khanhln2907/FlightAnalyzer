function fig = PlotTableData(DataTable, xVarName, yVarName, varargin)
% 	function fig = PlotTableData(DataTable, xVarName, yVarName, varargin)
% addRequired(p, 'DataTable');
% addRequired(p, 'xVarName');
% addRequired(p, 'yVarName');
% addParameter(p, 'xCaption', xVarName);
% addParameter(p, 'yCaption', yVarName);
% addParameter(p, 'LegendFormat', '%s');
% addParameter(p, 'LegendVar', 'RowNames');

p = inputParser;
addRequired(p, 'DataTable');
addRequired(p, 'xVarName');
addRequired(p, 'yVarName');
addParameter(p, 'xCaption', xVarName);
addParameter(p, 'yCaption', yVarName);
addParameter(p, 'LegendFormat', '%s');
addParameter(p, 'LegendVar', 'RowNames');

parse(p, DataTable, xVarName, yVarName, varargin{:});


fig = figure('name', yVarName);

for iDP = 1:height(DataTable)
	
	figure(fig);
	hold on;
	
	Y = DataTable.(p.Results.yVarName){iDP};
	X = DataTable.(xVarName){iDP};
	
	if strcmpi(p.Results.LegendVar , {'RowNames'})
		Name = DataTable.Properties.RowNames{iDP};
	else
		Name = DataTable.(p.Results.LegendVar)(iDP);
	end
	
	DispName = sprintf(p.Results.LegendFormat, Name);
	plot(X, Y, 'DisplayName', DispName);
end

legend('show', 'Location', 'best');
xlabel(p.Results.xCaption);
ylabel(p.Results.yCaption);
grid on;
end