function out = allign_ADIS(org)
    out = org;
    
    scaleGyro = [1, -1, -1];
    scaleAcc = [1, -1, -1];

    out.ATTITUDE_RATE_ADIS.p = out.ATTITUDE_RATE_ADIS.p * scaleGyro(1);
    out.ATTITUDE_RATE_ADIS.q = out.ATTITUDE_RATE_ADIS.q * scaleGyro(2);
    out.ATTITUDE_RATE_ADIS.r = out.ATTITUDE_RATE_ADIS.r * scaleGyro(3);
    out.ACCELERATION_ADIS_B.Ax = out.ACCELERATION_ADIS_B.Ax * scaleAcc(1);
    out.ACCELERATION_ADIS_B.Ay = out.ACCELERATION_ADIS_B.Ay * scaleAcc(2);
    out.ACCELERATION_ADIS_B.Az = out.ACCELERATION_ADIS_B.Az * scaleAcc(3);
end