function [isValid ,topicNameStr, payload] = ParseLine2(str)    
    try
        %% Compute the checksum of the payload
        %% Decoded JSON
        decodedData = JSONDecode(str);
        topicName = fieldnames(decodedData);
        if(numel(topicName) > 2)
           %fprintf('Two topics in one line detected. Not yet handled: \n %s', str);
           assert(false);
        end

        isValid = true;
        topicNameStr = topicName{1};
        payload = decodedData.(topicNameStr);
    catch ME
        topicNameStr = "NONE";
        isValid = false;
        payload = [];
        %fprintf('JSONdecode Failed. Line: %s. Mes: %s\n', str, ME.message);
    end
end

