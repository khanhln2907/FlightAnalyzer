fs = 100;
t = (0:1/fs:5)';

generate_coeff
filter = FIRFilter(coeff_fs100_LP5);

x = sin(2*pi*t) + sin(2*pi*11*t) + sin(2*pi*20*t) + sin(2*pi*40*t);
y = sin(2*pi*3*t) + 0.5*rand(size(t));

x = [x; y];
t = [t; t + max(t)];
x_filtered = zeros(numel(x),1);
for i = 1:numel(x)
    x_filtered(i) = filter.compute(x(i));
end

figure
plot(t, x);
hold on; grid on;
plot(t, x_filtered);

% spectrum
show_spectrum(x .* hanning(numel(x)), fs);
show_spectrum(x_filtered .* hanning(numel(x_filtered)), fs);