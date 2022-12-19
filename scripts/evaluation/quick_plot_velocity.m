velocityDataStr = ["VELOCITY_NED", "FCON_LOG_SP"];

t_min = -inf; 
t_max = inf;

for i = 1:numel(velocityDataStr)
     topicSample = dataTable.(velocityDataStr(i));
     dataVel.(velocityDataStr(i)) = get_topic_sample_interval(topicSample, t_min, t_max);
end

style = 0;
if(style == 0)
    figure
    ax = axes();
    plot_velocity_ned(dataVel, ax);
    plot_total_velocity(dataVel, ax);
else
    figure
    ax(1) = subplot(211);
    plot_velocity_ned(dataVel, ax(1));
    ax(2) = subplot(212);
    plot_total_velocity(dataVel, ax(1));
    linkaxes(ax, "x")
end