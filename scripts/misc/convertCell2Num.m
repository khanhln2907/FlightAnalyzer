function [table] = convertCell2Num(input)
%CONVERTCELL2NUM Summary of this function goes here
%   Detailed explanation goes here

    
    data = zeros(height(input),width(input));
    
    for i=1:width(input)
        data(:,i) = str2double(input(:,i).Variables);
    end
    
    table = array2table(data);
    table.Properties.VariableNames = input.Properties.VariableNames;
    
end

