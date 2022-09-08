function [out] = ReadDJIData(FileName)
%READDJIDATA Summary of this function goes here
%   Detailed explanation goes here

[~, parsedFileName, ~] = fileparts(FileName);
parsedFileName = sprintf("%s.mat", parsedFileName);

%% First, check if cached data is already available. If it is, load it.
if exist(parsedFileName, "file")
    load(parsedFileName);
    out = DJIData;
    return
end


s = fileread(FileName);
lines = regexpi(s, '^[^\n]+\n', 'match', 'lineanchors');
header = lines{1};

varSets = strsplit(header, ',');
varSets = varSets(1:end-2); % ignore last 2 columns that seem to contain version information

GPSColFilter = contains(varSets, 'GPS:');
GPSVarNames = varSets(GPSColFilter);

% newA = cellfun(@(x)strsplit(x, ',', 'CollapseDelimiters', false), lines, 'UniformOutput', false);
% newA = vertcat(newA{:}); % To remove nesting of cell array newA


% Read all lines and extract GPS data.
for iRow = 3:numel(lines)
    line = lines{iRow};
    
    LineValues = strsplit(line, ',', 'CollapseDelimiters',false);
    Values(iRow-2,:) = LineValues(GPSColFilter);
end

% Convert GPS time from string to datetime...
idxTime = find(strcmpi(GPSVarNames, 'GPS:dateTimeStamp'), 1);
TimeValues = Values(:, idxTime);
Time = datetime(TimeValues, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss''Z');

Values = str2double(Values);
out = array2table(Values);


VarNames = strrep(GPSVarNames, ':', '_');
VarNames = strrep(VarNames, 'GPS_Lat', 'Latitude');
VarNames = strrep(VarNames, 'GPS_Long', 'Longitude');
VarNames = strrep(VarNames, 'GPS_heightMSL', 'Altitude');

out.Properties.VariableNames = VarNames;
out.GPS_dateTimeStamp = [];
out.Time = Time;
[~, iA] = unique(out.Time);
out = out(iA, :);


% find unique GPS timestamps
out = sortrows(out, 'Time', 'ascend');
out = addprop(out, 'SourceFile', 'table');
out.Properties.CustomProperties.SourceFile = FileName;
out = AddUTMfromLatLong(out);
out.Time.TimeZone = 'utc';

% Convert MSL-referenced altitude to WGS84-referenced values.
out.Properties.VariableDescriptions{'Altitude'} = 'MSL';
end

