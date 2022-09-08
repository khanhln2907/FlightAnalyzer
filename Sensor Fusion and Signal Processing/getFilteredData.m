function [out] = getFilteredData(input, method, showFilter)
% Implementation of causal filtering methods
% Checking data parameters
n = numel(input);
out = zeros(n, 1);

if(method == "IIR")
    disp('Applied IIR Filter');
    % IIR Filter
    %NSECTION  = 1;
    %SOSMAT = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
    %SCALE = [1.0, 1.0];
    % 2
    NSECTION = 2;
    SOSMAT =    [[1.00, -1.0493, 1.00, 1.00, -1.7625, 0.7948];
                [1.00, -1.7559, 1.00, 1.00, -1.8423, 0.9370]];
    SCALE = [0.4007, 0.0293, 1.0];
    
    % 3
    %NSECTION = 3;
    %SOSMAT =    [[1.00, 2,    1.00, 1.00, 0.5594 , 0.8421];
    %            [1.00,  2.00, 1.00, 1.00, -0.1519, 0.4754];
    %            [1.00,  1.00, 0   , 1.00, -0.4302, 0]];
    %SCALE = [0.6004, 0.3309, 0.2849, 1.0];
    
    % 4 LP 50
    %NSECTION = 3;
    %SOSMAT = [[ 1.0,	-1.0878,	1.0,	1.0,	-1.4104,	0.7456];
    %          [ 1.0,	-0.2555,	1.0,	1.0,	-1.0284,	0.3537];
    %          [ 1.0,	1.0,		0.0,	1.0,	-0.4212,	0.0]];
    %SCALE = [0.3675, 0.1865, 0.2894, 1.0];

    
    myFilter = CascadeFilter(NSECTION, SOSMAT, SCALE);

    for i = 1 : n
        out(i) = myFilter.compute(input(i));
    end
elseif (method == "FIR")
    % FIR coeff: latest measurements at the end
    %COEFF = [0.1, 0.2, 0.2, 0.5];
    disp('Applied FIR Filter');
    COEFF = [0.1, 0.15, 0.2, 0.25, 0.3];
    gain = 1;
    myFilter = FIRFilter(COEFF);
    for i = 1 : n
        out(i) = gain * myFilter.compute(input(i));
    end
end
% Visualization
if(showFilter)
t = 1:n;
figure
plot(t, input, '*', 'Color', 'g', "LineWidth", 2.0);
hold on; grid on;
plot(t, out, '-', 'Color', 'r', "LineWidth", 1.0);
plot(t, smoothdata(input), '.', 'Color', 'y', "LineWidth", 1.0);
legend(["Real", "Filtered"])
title("")
end




