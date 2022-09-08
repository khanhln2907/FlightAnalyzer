function out = plot_Variables(ax, dataLOG, VarNames, t_min, t_max)
%PLOT_RCSWITCHES Adds a plot of the RC switches to the specified axes
%object.
%   Detailed explanation goes here


%% Iterate over all variable names and find the global Time min/max

if ~exist('t_min', 'var')
    for iVarName = 1:numel(VarNames)
        varName = VarNames{iVarName};
        Tab = findTable(dataLOG, varName); 

        if iVarName == 1
            t_min = min(Tab.Time);
            t_max = max(Tab.Time);
        else
            t_min = min(t_min, min(Tab.Time));
            t_max = max(t_max, max(Tab.Time));
        end
    end
end

hold(ax, 'on');

%% Plot all variables...
for iVarName = 1:numel(VarNames)
   varName = VarNames{iVarName};
   Tab = findTable(dataLOG, varName);
   
   filter = Tab.Time >= t_min & Tab.Time <= t_max;
   out.Lines(iVarName) = plot(ax, Tab.Time(filter), Tab.(varName)(filter), 'DisplayName', varName);    
end

out.XLabel = xlabel('Time[s]');
legend(ax, 'show');
grid(ax, 'on');

end


function Tab = findTable(dataLOG, VarName)

TabNames = fieldnames(dataLOG);

for iField = 1:length(TabNames)
    TabName = TabNames{iField};
    Tab = dataLOG.(TabName);
    
    if sum(strcmp(Tab.Properties.VariableNames, VarName)) > 0
        break;
    end    
end

end
