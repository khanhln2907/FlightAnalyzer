%% Check Valid Line
function [CS1, CS2] = CalculateChecksum(str)
    % Determine the payload of msg without CS
    CS1 = 0;
    CS2 = 0;
    % Fletcher16
    for k = 1: numel(str)
        CS1 = CS1 + str(k);
        CS2 = CS2 + CS1;
    end
    % Convert to uint8
    CS1 = mod(CS1,256);
    CS2 = mod(CS2,256); 
end
