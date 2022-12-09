function  show_spectrum(data,fs)
    data = detrend(data);
    [f,P] = perform_FFT(data, fs);
    figure
    stem(f, abs(P));
    hold on; grid on; 
    FormatFigure(gcf, 12, 12/8, 'MarkerSize', 2);
end

