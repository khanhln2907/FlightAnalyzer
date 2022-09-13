fs= 100;           % sampling ratio 
x = randn(1E+4,1); % first series
y = randn(1E+3,1); % second series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
[cc,lag] = fastercorr(x,y);
t1=toc;
disp(['fastercorr computation duration = ', num2str(t1) ]);
% plotting 
lag=lag/fs;
plot(lag,cc,'-k','LineWidth',0.1); 
grid on; set(gca,'XMinorGrid','on','YMinorGrid','on');
xlabel('lag'); ylabel('amplitude');
