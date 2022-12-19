function out = get_intpl_flight_mode(dataIn, t)    
    out.Time = t;
    tIntpl = interp1(dataIn.Time, dataIn.Time, t, "previous");
    [ia, ib] = ismember(tIntpl, dataIn.Time);
    out.FlightMode = dataIn.FlightMode(ib, :);
    out = struct2table(out);
end