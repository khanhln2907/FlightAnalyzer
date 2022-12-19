function out = preprocessing(filepath)
    handle = load(filepath);

    %% Visualize the data for interval selection
    % Get the data interval
    t_min_s = -inf;
    t_max_s = inf;

    topic = ["VELOCITY_NED","ATTITUDE_RATE","FILTERED_ATTITUDE_RATE","ATTITUDE","LIDAR_GROUND","AGL","OFS_PMW3901","OFS_THRONE"];
    for i = 1:numel(topic)
        data.(topic(i)) =  get_topic_sample_interval(handle.dataTable.(topic(i)), t_min_s, t_max_s);
    end

    %% Plot
    show_plots(data)
    
    figure
    subplot(211)
    plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelNorth, '-o');
    hold on; grid on; grid minor;
    plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelEast, '-o');
    plot(data.VELOCITY_NED.Time / 1e6, data.VELOCITY_NED.VelDown, '-o');
    legend(["velNorth", "VelEast", "VelDown"]);

    %%
    get_related_intpl_ofs_sample(data, data.VELOCITY_NED.Time, 'linear');
    [vxRef, vyRef] = tranVNED2Vb(data.VELOCITY_NED.VelNorth, data.VELOCITY_NED.VelEast,data.VELOCITY_NED.VelDown, data.ATTITUDE.Phi, data.ATTITUDE.Theta,data.ATTITUDE.Psi);
    subplot(212)
    plot(data.VELOCITY_NED.Time / 1e6, vxRef, '-o');
    hold on; grid on; grid minor;
    plot(data.VELOCITY_NED.Time / 1e6, vyRef, '-o');
    legend(["Vx", "Vy"]);
    
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 3);
    
    out = handle.dataTable;
end  
    
function [Vx, Vy, Vz] = tranVNED2Vb(VN, VE, VD, PhiDeg, ThetaDeg, PsiDeg)
    Phi = PhiDeg * pi/180;
    Theta = ThetaDeg * pi/180;
    Psi = PsiDeg * pi/180;
    
    func = trans_func();
    
    n = numel(VN);
    vOut = zeros(n, 3);
    for i = 1:n
        vOut(i,:) = func.ned_to_body([VN(i), VE(i), VD(i)]', Phi(i), Theta(i), Psi(i));
    end
    Vx = vOut(:,1);
    Vy = vOut(:,2);
    Vz = vOut(:,3);
end

