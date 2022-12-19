function [out] = calc_SmoothingCubicSpline(t_v, x_v, sigma_v, lambda)
    n = numel(t_v);                 % Amount of sample to induce the necessary segments
    t_v = reshape(t_v, [n,1]);        
    
    % Vectors and matrices for the optimization 
    h = diff(t_v);
    r = 3./h;    
    p = zeros(numel(h), 1);
    f = zeros(numel(h),1);
    p(1) = NaN;
    f(1) = NaN;
    for i = 2:numel(h)
        p(i) = 2 * (h(i-1) + h(i));
        f(i) = -(r(i-1) + r(i));
    end
    R = zeros(n-2, n-2);
    for i = 1:n-2
        R(i,i) = p(i+1);
        if(i > 1)
           R(i,i-1) = h(i);
           R(i-1,i) = h(i); 
        end
    end
    Q = zeros(n-2,n);
    for i = 1:n-2
       Q(i,i) = r(i);
       Q(i,i+1) = f(i+1);
       Q(i,i+2) = r(i+1);
    end

    %% Apply optimial results. 
    % The algorithm is here:  
    % https://www.researchgate.net/publication/241171192_Smoothing_with_Cubic_Splines
    Sigma = diag(sigma_v);
    mu = 2 * (1 - lambda)/(3*lambda);
    A = mu * Q * Sigma * Q' + R;
    y = reshape(x_v, [n,1]);
    
    % Declare the size to avoid error raised by simulink abount changing
    % size at run time
    b = zeros(n,1); % b(1) and b(n) = 0 according to the theory
    d = zeros(n,1);
    optimb = A\(Q*y);                    
    b(2:n-1) = optimb(:);
    
    d(:) = y - mu * Sigma * Q' * b(2:n-1);    % optimal d
    a = zeros(n-1,1);
    c = zeros(n-1,1);
    for i = 1: n-1
        a(i) = (b(i+1) - b(i)) / (3*h(i));                          % optimal a
        c(i) = (d(i+1) - d(i)) / h(i) - (b(i+1) + 2*b(i))* h(i)/3;  % optimal c
    end
    
    %% Output the full struct of coefficients
%     out.t = t_v;
%     out.a = a;
%     out.b = b;
%     out.c = c;
%     out.d = d;
    ppCoeff = zeros(n-1,4);
    ppCoeff(:,1) = a;
    ppCoeff(:,2) = b(1:n-1);
    ppCoeff(:,3) = c;
    ppCoeff(:,4) = d(1:n-1);
    
    %out = mkpp(t_v,ppCoeff); 
    %% Matlab does not 
    out.form = 'pp';
    out.breaks = t_v';
    out.coefs = ppCoeff;
    out.pieces = n-1;
    out.order = 4;
    out.dim = 1;
       
end

