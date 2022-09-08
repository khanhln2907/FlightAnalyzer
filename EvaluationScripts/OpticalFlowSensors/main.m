close all;

scale = 1;
pmw = dataTable.OFS_PMW3901((dataTable.OFS_PMW3901.Dx ~= 0 & dataTable.OFS_PMW3901.Dy ~= 0),:);
throne = dataTable.OFS_THRONE((dataTable.OFS_THRONE.Dx ~= 0 & dataTable.OFS_THRONE.Dy ~= 0),:);

pmw = dataTable.OFS_PMW3901;
throne = dataTable.OFS_THRONE;


%% DataMapping
% Already correct
%%

%% Visualization
figure
plot(pmw.Time / 1e6, pmw.Dx, '-o', "DisplayName", "PMW Dx");
hold on; grid on;
plot(pmw.Time / 1e6, pmw.Dy, '-o', "DisplayName", "PMW Dy");
plot(throne.Time / 1e6, throne.Dx / scale, '-o', "DisplayName", "Throne Dx");
plot(throne.Time / 1e6, throne.Dy / scale, '-o', "DisplayName", "Throne Dy");
legend
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);
xlabel("Time [s]")
ylabel("Motion")


%%
figure
plot(pmw.Time / 1e6, pmw.SurfaceQuality, '-o', "DisplayName", "PMW Squal");
hold on; grid on;
plot(throne.Time / 1e6, throne.SurfaceQuality, '-o', "DisplayName", "Throne Squal");
legend
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);
xlabel("Time [s]")
ylabel("Motion")

%%
figure
plot(dataTable.LIDAR_GROUND.Time / 1e6, dataTable.LIDAR_GROUND.Distance, '-o');
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);


%% Analysis
[c,lags] = xcorr(throne.Dx, pmw.Dx);
stem(lags,c)