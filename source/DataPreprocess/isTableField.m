function ret = isTableField(table,f)
    ret = any(f == string(table.Properties.VariableNames));
end

