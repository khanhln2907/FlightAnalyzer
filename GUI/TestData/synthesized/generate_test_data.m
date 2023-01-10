function data_table = generate_test_data(seedId)
    if(~exist("seedId", "var"))
       seedId = 1; 
    end
        rng(seedId);
    
    dt = 0.01;
    t = (0:dt:500-dt)';
    
    %% Sinus Data
    randSinFunc = @(A, t, f, nrA) A * sin(2* pi * f * t +  pi * rand(1,1)) + (A * nrA + (2* A * nrA) * rand(size(t))); % A * sin(2pif + df) + n
    
    % Low frequency data
    A = 10;
    a10f50Sig = randSinFunc(A, t, 50, 0.1);    
    a10f100Sig = randSinFunc(A, t, 100, 0.1);    
    a10f150Sig = randSinFunc(A, t, 150, 0.1);    

    % High frequency data
    A = 25;
    a25f800Sig = randSinFunc(A, t, 800, 0.1);
    a25f1200Sig = randSinFunc(A, t, 1200, 0.1);
    a25f1600Sig = randSinFunc(A, t, 1600, 0.1);
     
    % High Amplitude data
    A = 550;
    a550f10Sig = randSinFunc(A, t, 10, 0.05);
    a550f200Sig = randSinFunc(A, t, 200, 0.05);
    a550f600Sig = randSinFunc(A, t, 600, 0.05);
    

    % Categorical data

    
    %% Output
    
    data_table.a10f50 = TimeSeries(t , a10f50Sig, TSInfo("Synthesis", "a10f50", "No Unit", "a10", 50));
    data_table.a10f190 = TimeSeries(t , a10f100Sig, TSInfo("Synthesis", "a10f50", "No Unit", "a10", 100));
    data_table.a10f150 = TimeSeries(t , a10f150Sig, TSInfo("Synthesis", "a10f50", "No Unit", "a10", 150));
    data_table.a25f800 = TimeSeries(t , a25f800Sig, TSInfo("Synthesis", "a25f800", "No Unit", "a25", 800));
    data_table.a25f1200 = TimeSeries(t , a25f1200Sig, TSInfo("Synthesis", "a25f1200", "No Unit", "a25", 1200));
    data_table.a25f1600 = TimeSeries(t , a25f1600Sig, TSInfo("Synthesis", "a25f1600", "No Unit", "a25", 1600));
    data_table.a550f10 = TimeSeries(t , a550f10Sig, TSInfo("Synthesis", "a550f10", "No Unit", "a550", 10));
    data_table.a550f200 = TimeSeries(t , a550f200Sig, TSInfo("Synthesis", "a550f200", "No Unit", "a550", 200));
    data_table.a550f600 = TimeSeries(t , a550f600Sig, TSInfo("Synthesis", "a550f600", "No Unit", "a550", 600));
    
    [filePath,name,ext] = fileparts(which('generate_test_data'));
    savePath = fullfile(filePath,sprintf("synthesizedDataSeed%d.mat", seedId));
    save(savePath, 'data_table');
end






