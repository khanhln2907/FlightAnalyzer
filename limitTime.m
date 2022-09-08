function [out] = limitTime(dataLOG, tMin, tMax)
%% Limits all table present in the structure to tMin and tMax

FNames = fieldnames(dataLOG);

% iterate over all field names
for iName = 1:numel(FNames)
    FName = FNames{iName};
    
    if(istable(dataLOG.(FName)))
        if height(dataLOG.(FName)) > 0
            out.(FName) = limitTableTime(dataLOG.(FName), tMin, tMax);
        else
            out.(FName) = dataLOG.(FName);
        end  
    end
end


end



function [outTable] = limitTableTime(TableIn,tMin, tMax)
%% function [outTable] = limitTime(TableIn,tMin, tMax)

if( sum(strcmpi(TableIn.Properties.VariableNames, 'Time'))>0)
    try
    outTable = TableIn(TableIn.Time >= tMin & TableIn.Time < tMax, :);
    catch ex
        disp(ex);
    end
else
    outTable = TableIn;
end

end

