function [out] = plot_ofs_measurements(ax, sample)
    plot(ax, sample.Time/1e6, sample.Dx);
    
end

