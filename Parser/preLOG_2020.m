function [dataLOG,options] = preLOG_2020(options, varargin)
% Preprocess logged data
    
    
    % Define input parser
    p = inputParser;
    addParameter(p,'file', '1' , @ischar);    
    parse(p,varargin{:});

    % Read Log File
    if options.filePicker    
        % Input_table = readtable('D:\ISim_v0.32\scenarios\ekv_01v\Input.xlsx');
        dir = [pwd, ''];
        [file,path] = uigetfile(fullfile(dir,'*.txt*'),'LOG File auswaehlen');

        if ~file
            fprintf('\nVorgang wurde abgebrochen, da kein LOG File ausgewaehlt wurde)\n');
            return;
        else
            fLOG = fullfile(path,file);
            options.filename = erase(file,'.txt');
            options.filename = erase(file,'.TXT');
            dataLOG.Name = options.filename;
        end
    else
%         error('not yet implemented');      
         fLOG = fullfile(options.fullfile);          
    end
    
     s = fileread(fLOG);   
     
        %% Parse FCON_SP data.
    dataLOG.FCON_SP = ParseFCON_SP(s);
    dataLOG.FCON_SP_Rate = ParseFCON_SP_Rates(s);
    dataLOG.Gyro = ParseGyro(s);
    dataLOG.Receiver = ParseR(s);
    dataLOG.Lidar = ParseLidar(s);
    dataLOG.GPS = ParseGPS(s);
    dataLOG.OpticalFlow =  ParseOF(s);
    dataLOG.Target = ParseTGT(s);
    %dataTopics = ParseTopicStates(s);
    dataLOG.FCON_SP_Pos = ParseFCON_SP_Pos(s);
    
    dataLOG.FCON_SP_PH = ParseData(s, '(?<=^FCON_SP_PH )\d+( -?\d+\.\d+){4}(?=\s)', ...
        ['%d' repmat(' %f', [1,4])], ...
        {'Time', 'Lat'     , 'Lon'     , 'Alt'       , 'psidotNED'});
    dataLOG.FCON_SP_Vel = ParseData(s, '(?<=^FCON_SP_Vel )\d+( -?\d+\.\d+){4}(?=\s)', ...
        ['%d' repmat(' %f', [1,4])], ...
        {'Time', 'VelN'    , 'VelE'    , 'VelD'      , 'psiNED'});
    
    %_serial->printf("FCON_SP_VMan %d %f %f %f %f\n", Get_RelativeTime(), evt.velNed.VelNorth, evt.velNed.VelEast, evt.velNed.VelDown, evt.psiDotNED);
    dataLOG.FCON_SP_VMan = ParseData(s, '(?<=^FCON_SP_VMan )\d+( -?\d+\.\d+){4}(?=\s)', ...
         ['%d' repmat(' %f', [1,4])], ...
         {'Time', 'VelN'    , 'VelE'    , 'VelD'      , 'psiDotNED'});
     
     %_serial->printf("FCON_SP_TF %d %f %f %f %f\n", Get_RelativeTime(), evt.Lat, evt.Long, evt.AGL, evt.psiNED);
     dataLOG.FCON_SP_TF = ParseData(s,  '(?<=^FCON_SP_TF )\d+( -?\d+\.\d+){4}(?=\s)', ...
         ['%d' repmat(' %f', [1,4])], ...
        {'Time', 'Lat'     , 'Lon'     , 'AGL'       , 'psiNED'});

    %_serial->printf("FCON_SP_MIX %d %f %f %f %f\n", Get_RelativeTime(), evt.Tx, evt.Ty, evt.Tz, evt.Fz);
     dataLOG.FCON_SP_MIX = ParseData(s,  '(?<=^FCON_SP_MIX )\d+( -?\d+\.\d+){4}(?=\s)', ...
         ['%d' repmat(' %f', [1,4])], ...
         {'Time', 'Tx'      , 'Ty'      , 'Tz'        , 'Fz'});
            
    % Find SYNC timestamps...      
    %SYNC_Timestamps = str2double(regexp(s, '(?<=SYNC )[0-9]+(?=\s)', 'match'));
        
    
    % Convert time to seconds
    fname = fieldnames(dataLOG)';
    for i = 2: numel(fname)
        dataLOG.(cell2mat(fname(i))).Time = unwrapTime(dataLOG.(cell2mat(fname(i))).Time) / 1e6;        
    end
   

end


function FCON_SP_Pos = ParseFCON_SP_Pos(s)

FCON_SP_Pos = ParseData(s, '(?<=^FCON_SP_Pos )\d+ (-?\d+\.\d+ ){3}(-?\d+(\.\d+)?)( -?\d+\.\d+){2}(?=\s)', ...
        ['%d' repmat(' %f', [1,3]) ' %d %f %f'], ...
        {'Time', 'Lat'     , 'Lon'     , 'Alt'       , 'Altmode' , 'psiNED'      , 'maxVel'});
    
ELL = [FCON_SP_Pos.Lon, FCON_SP_Pos.Lat];
PRO=ell2tm(ELL, 'utm');
FCON_SP_Pos.utm_x = PRO(:,1);
FCON_SP_Pos.utm_y = PRO(:,2);  

end

function TableOut = ParseData(s, Regex, Format, VarNames)

% Filter out lines that match the expected format
lines = regexp(s, Regex, 'lineanchors', 'match');

if ~isempty(lines)
% extract numeric data.
Data = textscan(strjoin(lines), Format, 'ReturnOnError', 0);
else
    Data = [];
end
TableOut = MakeTable(Data, VarNames);

end

%% Ensures that the specified array increases monotonically, maintaining the relative distance between subsequent samples.
function [TimeOut] = unwrapTime(TimeArray)

TimeOut = TimeArray;
% 
% Find indices, at which time monotony is violated
% idxWrap = find(TimeArray(2:end)-TimeArray(1:end-1) < 0);
% 
 % Assume, that the time re-starts at 0. Add the time, at which wrapping
% % occurs to all later samples.
% for i = 1:length(idxWrap)
%     Time_PreWrap = TimeOut(idxWrap(i));
%     Time_PostWrap = TimeOut(idxWrap(i)+1);
%     
%     TimeOut(idxWrap(i)+1:end) = TimeOut(idxWrap(i)+1:end) + Time_PreWrap;    
% end


end


function [SP_RateData] = ParseFCON_SP_Rates(s)


VarNames = {'Time', 'p'       , 'q'       , 'r'         , 'Thrust'};

% Filter out lines that match the expected format
lines = regexp(s, '(?<=^FCON_SP_Rate )\d+ (-?\d+\.\d+ ){3}(-?\d+\.\d+)(?=\r)', 'lineanchors', 'match');

if ~isempty(lines)
% extract numeric data.
Data = textscan(strjoin(lines), '%d %f %f %f %f', 'ReturnOnError', 0);
else
    Data = [];
end
SP_RateData = MakeTable(Data, VarNames);
end

function [GData] = ParseGyro(s)


VarNames = {'Time', 'Count'   , 'phi'     , 'theta'     , 'psi'     , 'a_x'         ,'a_y'        ,'a_z'          , 'p', 'q', 'r', 'p_f', 'q_f', 'r_f'};    


% Filter out lines that match the expected format
lines = regexp(s, '(?<=^G )\d+ \d+ (-?\d+\.\d+ ){12}(?=%\s)', 'lineanchors', 'match');

if ~isempty(lines)
% extract numeric data.
Data = textscan(strjoin(lines), '%d %d %f %f %f %f %f %f %f %f %f %f %f %f', 'ReturnOnError', 0);
else
    Data = [];
end
GData = MakeTable(Data, VarNames);
end


function [FCON_SP] = ParseFCON_SP(s)

SPNames = {'p', 'q', 'r', 'F', 'Phi', 'Theta', 'Psi', 'Psi_dot', 'VelN', 'VelE', 'VelD', ...
    'Lat', 'Long', 'Alt', 'V_Max', 'AGL'};

VarNames = {'Time'};

for iName = 1:length(SPNames)
   VarNames = [VarNames sprintf('%s_Prio',SPNames{iName}), sprintf('%s_Value', SPNames{iName})];    
end

% Filter out lines that match the expected format
FCON_lines = regexp(s, '(?<=^FCON_SP )\d+ ([0-5] -?[0-9]+\.[0-9]+ ){15}\d -?[0-9]+\.[0-9]+\r\n', 'lineanchors', 'match');

% extract numeric data.
    if ~isempty(FCON_lines)

        FCON_Data = textscan(strjoin(FCON_lines), ['%d' repmat(' %d %f', [1,16])], 'ReturnOnError', 0);

        % Create Table
        FCON_SP = MakeTable(FCON_Data, VarNames);

        cats = categorical({'IDLE', 'RATE', 'ATTITUDE', 'VEL_MAN', 'VEL_AUTO', 'TERRAIN', 'POS'});

        %% Identify flight modes from prioritiev
        FCON_SP = [FCON_SP table('Size', [height(FCON_SP) 1], 'VariableTypes', {'categorical'}, 'VariableNames', {'FlightMode'})];
        FCON_SP.FlightMode(:) = cats(1);
        % Rate mode = 1
        FCON_SP.FlightMode((FCON_SP.p_Prio == 5) & (FCON_SP.q_Prio == 5) & (FCON_SP.r_Prio == 5) & ...
            (FCON_SP.F_Prio == 5)) = cats(2);

        % Attitude mode = 2
        FCON_SP.FlightMode((FCON_SP.Phi_Prio == 5) & (FCON_SP.Theta_Prio == 5) & (FCON_SP.Psi_dot_Prio == 5) & ...
            (FCON_SP.F_Prio == 5)) = cats(3);

        % Velocity manual mode = 3
        FCON_SP.FlightMode((FCON_SP.VelN_Prio == 5) & (FCON_SP.VelE_Prio == 5) & (FCON_SP.Psi_dot_Prio == 5) & ...
            (FCON_SP.VelD_Prio == 5)) = cats(4);

        % Velocity auto mode = 4
        FCON_SP.FlightMode((FCON_SP.VelN_Prio == 5) & (FCON_SP.VelE_Prio == 5) & (FCON_SP.Psi_Prio == 5) & ...
            (FCON_SP.VelD_Prio == 5)) = cats(5);

        % Position TerrainFollow mode = 5
        FCON_SP.FlightMode((FCON_SP.Lat_Prio == 5) & (FCON_SP.Long_Prio == 5) & (FCON_SP.Psi_Prio == 5) & ...
            (FCON_SP.AGL_Prio == 5)) = cats(6);

        % Position mode = 6
        FCON_SP.FlightMode((FCON_SP.Lat_Prio == 5) & (FCON_SP.Long_Prio == 5) & (FCON_SP.Psi_Prio == 5) & ...
            ((FCON_SP.AGL_Prio == 5) | (FCON_SP.Alt_Prio == 5))) = cats(7);


        % Check if any of the priorities is above the expected level...
        idxPrios = contains( FCON_SP.Properties.VariableNames, '_Prio');
        PrioTable = FCON_SP(:, idxPrios);

        errors = table2array(PrioTable) > 8;
        [row, col] = find(errors);
        if  ~isempty(row)
           disp('Warning! Priority exceeds expected value:');
           for i = 1:numel(row)
              RowData = PrioTable(row(i), :)

           end
        end
    else
        FCON_Data = [];
        FCON_SP = MakeTable(FCON_Data, VarNames);
    end
end



function [R] = ParseR(s)


VarNames = {'Time', 'Count'   , 'p_comm'  , 'q_comm'    , 'r_comm'  , 'thrust_comm' ,'FlightMode' ,'KillSwitch'};

% Filter out lines that match the expected format
R_lines = regexp(s, '(?<=^R )\d+ \d+ (-?[0-9]+\.[0-9]+ ){4}\d \d(?= §\r\n)', 'lineanchors', 'match');

% extract numeric data.
if ~isempty(R_lines)
    RData = textscan(strjoin(R_lines), ['%d' '%d' repmat(' %f', [1,4]) '%d' '%d'], 'ReturnOnError', 0);
    % Prepare empty table
    nColumns = length(RData);
    nRows = length(RData{1});
    R = table('Size', [nRows nColumns], 'VariableTypes', repmat({'double'}, [1 nColumns]), 'VariableNames', VarNames);

    % Unpack data into columns
    for iColumn = 1:nColumns
        try
       R{:, iColumn} = RData{iColumn};
        catch
           disp(RData{iColumn}); 
        end
    end
else
    Data = [];
    R = MakeTable(Data, VarNames);
end

end

function [TableData] = MakeTable(Data, VarNames)

% Prepare empty table
nColumns = length(VarNames);
if ~isempty(Data)
nRows = length(Data{1});
else
    nRows = 0;
end
TableData = table('Size', [nRows nColumns], 'VariableTypes', repmat({'double'}, [1 nColumns]), 'VariableNames', VarNames);

if ~isempty(Data)
% Unpack data into columns
for iColumn = 1:nColumns
    try
   TableData{:, iColumn} = Data{iColumn};
    catch
       disp(Data{iColumn}); 
    end
end
end

end

function [LidarTable] = ParseLidar(s)

VarNames = {'Time', 'Count', 'Distance', 'Strength', 'AGL', 'FirstRaw', 'LastMedian', 'LastRaw'};

% Filter out lines that match the expected format
%lines = regexp(s, '(?<=^L )\d+ \d+ (-?\d+\.\d+) \d+ (-?\d+\.\d+)(?= \$\n)', 'lineanchors', 'match');
lines = regexp(s, '(?<=^L )\d+ \d+ (-?\d+\.\d+) \d+ (-?\d+\.\d+) (-?\d+\.\d+) (-?\d+\.\d+) (-?\d+\.\d+)(?= \$\n)', 'lineanchors', 'match');
% extract numeric data if they are found.
    if(~isempty(lines))
        LidarData = textscan(strjoin(lines), '%d %d %f %d %f %f %f %f', 'ReturnOnError', 0);
        LidarTable = MakeTable(LidarData, VarNames);
        % Replace distance values greater than 655, since these indicate errors for
        % the TFMini and just pollute the data. Replace them with zeros.
        filter = LidarTable.Distance > 655;
        LidarTable(filter, 'Distance') = repmat({0}, [sum(filter) 1]);
    else
        LidarData = [];
        LidarTable = MakeTable(LidarData, VarNames);
    end
end


function [GPSTable] = ParseGPS(s)

VarNames = {'Time', 'Count'   , 'Year'    , 'Month'     , 'Day'     , 'h'           , 'm'         , 's'           , 'Lat'     , 'Lon'       , 'Alt'     , 'V_north'     ,'V_east'     ,'V_down'};

% Filter out lines that match the expected format
lines = regexp(s, '(?<=^GPS )\d+ \d+ (\d?\d ){6}(-?[0-9]+\.[0-9]+ ){6}(?=&\s)', 'lineanchors', 'match');

if(~isempty(lines))
    % extract numeric data.
    GPSData = textscan(strjoin(lines), '%d %d %d %d %d %d %d %d %f %f %f %f %f %f', 'ReturnOnError', 0);

    % Prepare empty table
    nColumns = length(GPSData);
    nRows = length(GPSData{1});
    GPSTable = table('Size', [nRows nColumns], 'VariableTypes', repmat({'double'}, [1 nColumns]), 'VariableNames', VarNames);

    % Unpack data into columns
    for iColumn = 1:nColumns
        try
       GPSTable{:, iColumn} = GPSData{iColumn};
        catch
           disp(GPSData{iColumn}); 
        end
    end

    % Replace distance values greater than 655, since these indicate errors for
    % the TFMini and just pollute the data. Replace them with zeros.
    % filter = GPSData. > 655;
    % GPSData(filter, 'Distance') = repmat({0}, [sum(filter) 1]);


    %% Convert WGS-84 to UTM coordinates...
    ELL = [GPSTable.Lon, GPSTable.Lat];
    PRO=ell2tm(ELL, 'utm');
    GPSTable.utm_x = PRO(:,1);
    GPSTable.utm_y = PRO(:,2);

else
    GPSData = [];
    GPSTable = MakeTable(GPSData, VarNames);
end

end

function [TopicStateTable] = ParseTopicStates(s)


TopicNames = {'Position', 'Velocity', 'GPSTime', 'Attitude', 'AttitudeRate', ...
    'Acceleration', 'RCAxes', 'RCMode', 'RCKillSwitch', 'Lidar', ...
    'TargetDirection', 'TargetPosition', 'TargetVelocity', 'AGL', ...
    'GroundAltitude', 'FilteredAcceleration', 'FilteredAttitudeRate'};

TopicIDs = linspace(401, 401+numel(TopicNames), numel(TopicNames)+1);

VarNames = ['Time',TopicNames];


% Filter out lines that match the expected format
lines = regexp(s, '(?<=^TOPIC_STATE )\d+ \d+', 'lineanchors', 'match');

% extract numeric data.
LidarData = textscan(strjoin(lines), '%d %d', 'ReturnOnError', 0);

LidarTable = MakeTable(LidarData, VarNames);

end

function [TGTData] = ParseTGT(s)


VarNames = {'Time', 'Count', 'Lat', 'Long', 'Alt', 'v_x', 'v_y', 'v_z', 'Az', 'El'};

% Filter out lines that match the expected format
lines = regexp(s, '(?<=^TGT )\d+ \d+ (-?\d+\.\d+ ){7}(-?\d+\.\d+)(?=\n)', 'lineanchors', 'match');

if ~isempty(lines)
% extract numeric data.
Data = textscan(strjoin(lines), '%d %d %f %f %f %f %f %f %f %f', 'ReturnOnError', 0);
else
    Data = [];
end
TGTData = MakeTable(Data, VarNames);

% ELL = [TGTData.Long, TGTData.Lat];
% PRO=ell2tm(ELL, 'utm');
% TGTData.utm_x = PRO(:,1);
% TGTData.utm_y = PRO(:,2);

end

function [OFTable] = ParseOF(s)

VarNames = {'Time', 'Count', 'DX', 'DY', 'Status', 'Squal'};

% Filter out lines that match the expected format
lines = regexp(s, '(?<=^OF )\d+ \d+ (-?\d+) (-?\d+) (\d+|\w\d) \d+ (?=\*\n)', 'lineanchors', 'match');

% extract numeric data if they are found.
    if(~isempty(lines))
        OFData = textscan(strjoin(lines), '%d %d %d %d %2s %d', 'ReturnOnError', 0);
    else
        OFData = [];
    end
    OFTable = MakeTable(OFData, VarNames);
end