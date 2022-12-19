function Table = AddUTMfromLatLong(Table)

utm = ell2tm([Table.Longitude, Table.Latitude], 'utm');
Table.utm_x = utm(:,1);
Table.utm_y = utm(:,2);

end

