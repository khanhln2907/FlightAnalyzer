%% Get ts from datasample
[info] = SensorInfo();
dataHandle = load("flight_data_parsed_09-Sep-2022.mat");
dataTable = dataHandle.data_table;

%% Translate the topics into time series
out = Topics2Ts(dataTable, "ATTITUDE", info.vn200.att);
[dataTable.VN200_Phi, dataTable.VN200_Theta,dataTable.VN200_Psi] = out{1:3};

out = Topics2Ts(dataTable, "ATTITUDE_RATE", info.vn200.rate);
[dataTable.VN200_p, dataTable.VN200_q,dataTable.VN200_r] = out{1:3};





















%% Get all sensor info
function [info] = SensorInfo()
    info.vn200 = getVn200Info();
    info.lw200 = getLW20Info();
end

%% Source | DataField | Unit | AxisLabel | Fs
function vn200 = getVn200Info()
    vn200.rate = TopicInfo("VN200", ["p", "q", "r"], "rad/s", "RATE", 800);
    vn200.att = TopicInfo("VN200", ["Phi", "Theta", "Psi"], "deg", "ATTITUDE", 400);
    vn200.vel = TopicInfo("VN200", ["VelNorth", "VelEast", "VelDown"], "m/s", "VELOCITY", 100);    
    vn200.pos = TopicInfo("VN200", ["Latitude", "Longitude"], "deg", "WGS84", 10);
end

function lw20 = getLW20Info()
    lw20.d = TopicInfo("LW20", ["Distance", "FirstRaw", "LastRaw"], "m", "Distance", 249);
    lw20.ss = TopicInfo("LW20", ["SS1", "SS2"], "", "Strength", 249);
end