fs = 100;
t = (0:1/fs:5)';
x = sin(2*pi*t) + sin(2*pi*11*t) + sin(2*pi*20*t) + sin(2*pi*40*t);
y = sin(2*pi*3*t) + 0.5*rand(size(t));
sum = (x.^2 + y.^2).^(1/2);

% spectrum
[fx,Px] = perform_FFT(detrend(x), fs);
[fy,Py] = perform_FFT(detrend(y), fs);
[fTot,PTot] = perform_FFT(detrend(sum), fs);


figure
subplot(2,1,1);
plot(t, x);
hold on; grid on;
plot(t, y);
plot(t, sum);
legend(["x","y", "tot"]);
xlabel("Time");
ylabel("Signal");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);

subplot(2,1,2)
stem(fx, abs(Px));
hold on; grid on;
stem(fy, abs(Py));
stem(fTot, abs(PTot));
legend(["Px","Py", "PTot"]);
xlabel("Hz");
ylabel("Spectrum");
FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);




