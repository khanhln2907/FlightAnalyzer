function cross_correlation(sig1, sig2)
    n = numel(sig1) + numel(sig2) - 1;
    

end



orig1 = target_info.Theta_Enc';
mean(diff(uav_att.Time))
orig2 = interp1(uav_att.Time, uav_att.Theta, uav_calc.Time, 'linear')';
h = flipud(orig2);
lx=length(orig1);
lh=length(h);
n=lx+lh-1;
hh=[h zeros(1,n-lh)];
xx=zeros(n);
xx(1:lx,1)=orig1;
for i=2:n
    for j=2:n
        xx(j,i)=xx(j-1,i-1);    
    end
end
yy=xx*hh';

figure
subplot(3,1,1);
stem(orig1);
title('1st sequence');
subplot(3,1,2);
stem(orig2);
title('2nd sequence');
subplot(3,1,3);
stem(yy);
disp('cross correlate o/p->');
title('y=cross correlastion of x & j');

