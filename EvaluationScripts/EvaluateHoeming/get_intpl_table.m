function [out] = get_intpl_table(dataIn, t, method)
    fNames = dataIn.Properties.VariableNames;
    out.Time = t;
    for i = 1:numel(fNames)
        if(fNames{i} ~= "Time")
            out.(fNames{i}) = interp1(dataIn.Time, dataIn.(fNames{i}), t, method);
        end
    end
    out = struct2table(out);
end

