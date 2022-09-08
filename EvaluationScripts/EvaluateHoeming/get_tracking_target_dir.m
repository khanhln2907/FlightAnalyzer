function [TARGET_DIR] = get_tracking_target_dir(t, modeTimeArr, dataSP)
    fMode = get_intpl_flight_mode(modeTimeArr, t);
    TARGET_DIR = get_intpl_table(dataSP, t, "previous");
    TARGET_DIR{fMode.FlightMode ~= "DIR", :} = NaN;
end

