close all;


x = @(t) 1 * t.^3 + 25 * t.^2 + 9* t + 5;
y = @(t) -5 * t.^3 + 36 * t.^2 - 3* t + 5;
z = @(t) -4 * t.^3 + 28 * t.^2 + 1* t + 5;    

dx = @(t) 3 * t.^2 + 50 * t + 9;
dy = @(t) -15 * t.^2 + 72 * t - 3;
dz = @(t) -12 * t.^2 + 56 * t + 1;

ddx = @(t) 6 * t + 50;
ddy = @(t) -30 * t + 72;
ddz = @(t) -24 * t + 56;

nPoints = 200;
nInterpolated = 10;
noiseMag = 1;
lambda = 0.1; %0.99999;

t = linspace(-1,20, nPoints)';
origin_samples = sin(t);
noise = -noiseMag + (noiseMag + noiseMag)*rand(numel(origin_samples),1);
samples = origin_samples + noise;
sigma = sqrt(noiseMag) * ones(numel(samples),1); 
[cbspline] = calc_SmoothingCubicSpline(t, samples, sigma, lambda);

plot(t, samples, "*", "DisplayName", "Samples");
hold on;
plot(t, origin_samples, "LineStyle", "-", "LineWidth", 2, "DisplayName", "Referrences");

intrpl_t = t(1):0.001:(t(end)+0.8);
intrpl_p = ppval(cbspline, intrpl_t);
plot(intrpl_t, intrpl_p, "LineWidth", 2);











