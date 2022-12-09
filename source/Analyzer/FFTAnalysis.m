function [out] = FFTAnalysis(dataArr)
rng('default')
fs = 100;                               % sample frequency (Hz)
n = length(dataArr);
%t = 1: n;
f = (0:n-1)*(fs/n);                     % frequency range


y = fft(dataArr);
power = abs(y).^2/n;
figure
plot(f,power, "LineWidth", 2.0);
hold on; grid on;
plot(f, y);

end

