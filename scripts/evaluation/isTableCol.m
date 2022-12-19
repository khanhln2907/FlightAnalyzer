function [isTableCol] = isTableCol(dataTable, var)
        isTableCol_func = @(t, thisCol) ismember(thisCol, t.Properties.VariableNames);
        isTableCol = true;
        for i = 1: numel(var)
            isTableCol = isTableCol & isTableCol_func(dataTable, var{i});
        end
end

