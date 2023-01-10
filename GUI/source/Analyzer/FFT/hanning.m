function w = hanning(n)
    w = zeros(n,1);
    for i = 1:n
        w(i) = 0.5 - 0.5*cos(2*pi*i/n);
    end
end