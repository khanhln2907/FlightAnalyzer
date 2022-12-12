%% Get all sensor info
function [info] = SensorInfo()
    info.vn200 = getVn200Info();
    info.lw20 = getLW20Info();
    info.sp = getRateSpInfo();
end

%% Source | DataField | Unit | AxisLabel | Fs
function vn200 = getVn200Info()
    vn200.rate = TopicInfo("VN200", ["p", "q", "r"], "rad/s", "RATE", 800);
    vn200.frate = TopicInfo("VN200_FILTERRED", ["p", "q", "r"], "rad/s", "RATE", 800);
    vn200.att = TopicInfo("VN200", ["Phi", "Theta", "Psi"], "deg", "ATTITUDE", 400);
    vn200.vel = TopicInfo("VN200", ["VelNorth", "VelEast", "VelDown"], "m/s", "VELOCITY", 100);    
    vn200.pos = TopicInfo("VN200", ["Lat", "Lon"], "deg", "WGS84", 10);
end

function lw20 = getLW20Info()
    lw20.d = TopicInfo("LW20", ["Distance", "FirstRaw", "LastRaw"], "m", "Distance", 249);
    lw20.ss = TopicInfo("LW20", ["SS1", "SS2"], "", "Strength", 249);
end

function sp = getRateSpInfo()
    sp.rate = TopicInfo("SP", ["p", "q", "r"], "rad/s", "RATE", 800);
    sp.att = TopicInfo("SP", ["Phi", "Theta", "Psi"], "deg", "ATTITUDE", 400);
    sp.vel = TopicInfo("SP", ["VelNorth", "VelEast", "VelDown"], "m/s", "VELOCITY", 100);    
    sp.pos = TopicInfo("SP", ["Lat", "Lon"], "deg", "WGS84", 10);
end