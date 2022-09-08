function [dataTable] = Post_Parsing(dataTable)
    format long;
    uiSelected = false;
    
    if(~exist('dataTable', 'Var'))
        %% Select the report file for parsing
        dir = [pwd, ''];
        [file,path] = uigetfile(fullfile(dir,'*.m*'),'Choose Log File \n');
        if ~file
            fprintf('No Log file selected. Abort ... \n');
            dataTable = 0;
            return;
        else
            uiSelected = true;
            dataTable = load(fullfile(path, file), 'dataTable');
        end
    end
    
    %%  Append UTM GPS data from WGS84
    %% Convert WGS-84 to UTM coordinates...
    gpsWGSField = ["POSITION_NED", "POSITION", "FCON_SET_POSITION_SIG", "FCON_SET_TERRAIN_SIG", "FCON_LOG_SP"];
    for i = 1: numel(gpsWGSField)
        curField = gpsWGSField{i};
        if(isfield(dataTable, curField))
            PROpos = ell2tm([dataTable.(curField).Lon, dataTable.(curField).Lat], 'utm');
            dataTable.(curField).UTMCoord_x = PROpos(:,1);
            dataTable.(curField).UTMCoord_y = PROpos(:,2);
        end
    end
    
    %% Get UTC-Time range of current data.
    if(isfield(dataTable, 'GPS_TIME'))
        T = dataTable.GPS_TIME;
        dataTable.GPS_TIME.DateTime = datetime(T.Year+2000, T.Month, T.Day, T.Hour, T.Minute, T.Second, T.FracSecond,"TimeZone","UTC");
        Tvalid = dataTable.GPS_TIME.DateTime(dataTable.GPS_TIME.State == 3);
        t_min = min(Tvalid);
        t_max = max(Tvalid);
        dataTable.UTC_Range = [t_min, t_max];
    end
    
    try
    %% Do something else
    % ...
    %
    % Add Killswitch Categorical
    KSState = repmat(categorical({'DISARMED'}), [height(dataTable.RC_KILLSWITCH), 1]);
    KSState(dataTable.RC_KILLSWITCH.Value == 0) = categorical({'ARMED'});
    dataTable.RC_KILLSWITCH.KSState = KSState;
    
    % Map RC Mode to Control-state
    ModeState = repmat(categorical({'ATTITUDE'}), [height(dataTable.RC_MODE), 1]);
    ModeState(dataTable.RC_MODE.Value == 1) = categorical({'VELOCITY'});
    ModeState(dataTable.RC_MODE.Value == 2) = categorical({'AUTO'});
    dataTable.RC_MODE.ControlMode = ModeState;
    
    % Assemble and sort all flight commands into a single table
    SPTable = CreateSPTable(dataTable, 'FCON_SET_ATTITUDE_SIG', 'ATT');
    SPTable = [SPTable; CreateSPTable(dataTable, 'FCON_SET_VELOCITY_SIG', 'VEL')];
    SPTable = [SPTable; CreateSPTable(dataTable, 'FCON_SET_POSITION_SIG', 'POS')];
    SPTable = [SPTable; CreateSPTable(dataTable, 'FCON_SET_TERRAIN_SIG', 'TF')];
    if (~isempty(SPTable))
        SPTable = sortrows(SPTable, 'Time');
        dataTable.FCON_SP_ALL = SPTable;
    end
    
    %% Extract flight mode from controller setpoint priorities
        cats = categorical({'IDLE', 'RATE', 'ATTITUDE', 'VEL_MAN', 'VEL_AUTO', 'TERRAIN', 'POS', 'DIR'});
        
        FCON_SP = [dataTable.FCON_LOG_SP table('Size', [height(dataTable.FCON_LOG_SP) 1], 'VariableTypes', {'categorical'}, 'VariableNames', {'FlightMode'})];
        FCON_SP.FlightMode(:) = cats(1);
        % Rate mode = 1
        FCON_SP.FlightMode((FCON_SP.Priop == 5) & (FCON_SP.Prioq == 5) & (FCON_SP.Prior == 5) & ...
            (FCON_SP.PrioThrust == 5)) = cats(2);

        % Attitude mode = 2
        FCON_SP.FlightMode((FCON_SP.PrioPhi == 5) & (FCON_SP.PrioTheta == 5) & (FCON_SP.PrioPsi_dot == 5) & ...
            (FCON_SP.PrioThrust == 5)) = cats(3);

        % Velocity manual mode = 3
        FCON_SP.FlightMode((FCON_SP.PrioVelNorth == 5) & (FCON_SP.PrioVelEast == 5) & (FCON_SP.PrioPsi_dot == 5) & ...
            (FCON_SP.PrioVelDown == 5)) = cats(4);

        % Velocity auto mode = 4
        FCON_SP.FlightMode((FCON_SP.PrioVelNorth == 5) & (FCON_SP.PrioVelEast == 5) & (FCON_SP.PrioPsi == 5) & ...
            (FCON_SP.PrioVelDown == 5)) = cats(5);

        % Position TerrainFollow mode = 5
        FCON_SP.FlightMode((FCON_SP.PrioLat == 5) & (FCON_SP.PrioLon == 5) & (FCON_SP.PrioPsi == 5) & (FCON_SP.PrioAGL == 5)) = cats(6);

        % Position mode = 6
        FCON_SP.FlightMode((FCON_SP.PrioLat == 5) & (FCON_SP.PrioLon == 5) & (FCON_SP.PrioPsi == 5) & (FCON_SP.PrioAlt == 5)) = cats(7);

        % Direction mode (HomeDirection)
        FCON_SP.FlightMode((FCON_SP.PrioDirNorth == 5) &(FCON_SP.PrioDirEast == 5) & (FCON_SP.PrioDirDown == 5)) = cats(8);

        % Check if any of the priorities is above the expected level...
        idxPrios = contains( FCON_SP.Properties.VariableNames, 'Prio');
        PrioTable = FCON_SP(:, idxPrios);

        errors = table2array(PrioTable) > 8;
        [row, col] = find(errors);
        if  ~isempty(row)
           disp('Warning! Priority exceeds expected value:');
           for i = 1:numel(row)
              RowData = PrioTable(row(i), :)

           end
        end
        
        dataTable.FCON_LOG_SP = FCON_SP;
    
    catch ME
        fprintf("Error Post Parsing: %s", ME.message);
    end
        
    %% Overwrite the parsed file with new data added
    if(uiSelected)
        dataTable.evaluation.FilePath = fullfile(path, file);
        fprintf("Saved post processing parsed file into %s", fullfile(path, file));
        save(fullfile(path, file), "dataTable");
    end
end


function SPT = CreateSPTable(dataTable, VarName, CatString)
    
    if(isfield(dataTable,VarName))
        SPTable = dataTable.(VarName);
        Time = SPTable.Time;
        SPT = table(Time, repmat(categorical({CatString}), [numel(Time), 1]));
        SPT.Properties.VariableNames = {'Time', 'Category'};
    else
        SPT = [];
    end
end