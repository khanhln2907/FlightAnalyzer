function [out] = interpolate_SmoothingCubiscSline(ts, samples, resolution, sigma_v, lambda)
    [out] = calc_SmoothingCubicSpline(ts, samples, sigma_v, lambda);

    
%     
%     nSegments = numel(s.t) - 1;
%     out = zeros(nSegments * resolution, 2);
%     for i = 1:nSegments
%        t_Int = linspace(ts(i),ts(i+1),resolution);
%        out((i-1)*resolution + 1: i *resolution, 1) = t_Int(:);
%        out((i-1)*resolution + 1: i *resolution, 2) = s.a(i) .* (t_Int - s.t(i)).^3 + s.b(i) .* (t_Int - s.t(i)).^2 + s.c(i) .* (t_Int - s.t(i)) + s.d(i);
%     end
%     
%     coeff = [s.a(end), s.b(end), s.c(end), s.d(end)];
    
    
    
end

