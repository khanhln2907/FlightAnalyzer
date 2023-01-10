function [dataTable] = getVN200Data(dataTable)
    AttTopicInfo.Name = "VN200";
    AttTopicInfo.Unit = "deg";
    AttTopicInfo.fs  = 800;
    out = Topics2Ts(dataTable, "ATTITUDE", ["Phi", "Theta", "Psi"], AttTopicInfo);
    [dataTable.VN200_Phi, dataTable.VN200_Theta,dataTable.VN200_Psi] = out{1:3};

    RateTopicInfo.Name = "VN200";
    RateTopicInfo.Unit = "rad/s";
    RateTopicInfo.fs  = 800;
    out = Topics2Ts(dataTable, "ATTITUDE_RATE", ["p", "q", "r"], RateTopicInfo);
    [dataTable.VN200_p, dataTable.VN200_q,dataTable.VN200_r] = out{1:3};

end

