%% Wrap function to modifiy the string before using matlab jsondecode builtin function
function outStruct = JSONDecode(txtLine)
    formartedLine = sprintf('{%s}', txtLine);
    %outStruct = loadjson(formartedLine); Test other library but still slow
    outStruct = jsondecode(formartedLine);
end