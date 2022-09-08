close all; clear;
%% Read in sensor data
if(exist('dataTable','var'))

else
   dataHandle = load('FlightLogs\2022-02-01\K2\Parsed_LOG00003.mat'); 
   dataTable = dataHandle.dataTable;    
end


% Find timestamps where Homeing Controller was active
ActiveHomeing = dataTable.FCON_LOG_SP.PrioDirMaxV == 5;
%%% Reset ActiveHomeing to zero when values no longer update (Priority
%%% should actually reset)
% ActiveHomeing(15141:end) = 0 ;% enter manual if priority bug still present
% ActiveHomeing(10519:end) = 0 ;% enter manual if priority bug still present
ActiveHomeing(18635:end) = 0 ;% LOG00003, enter manual if priority bug still present
TimeHomeing = dataTable.FCON_LOG_SP.Time(ActiveHomeing);

%%% Gimbal data
% Get unique samples
[EncoderTime,idx_enc] = unique(dataTable.TARGET_INFO.TimeEncoder);
EncoderData = dataTable.TARGET_INFO(idx_enc,["Phi_Enc","Theta_Enc","Psi_Enc"]);

%%% UAV attitude data
% Get unique samples
[AttTime,idx_att] = unique(dataTable.ATTITUDE.Time);
AttData = dataTable.ATTITUDE(idx_att,["Phi","Theta","Psi"]);


%% Determine sensor sample cubic splines

%%%%%%%%%%%%%%% @Khan
% How to use these functions (calc_SmoothingCubicSpline, ppval) properly 
% with actual data (gimbal, camera, Att,..)?

% Gimbal
Phi_Enc_spline = calc_SmoothingCubicSpline(dataTable.TARGET_INFO.TimeEncoder(1:20)-dataTable.TARGET_INFO.TimeEncoder(1),...
    dataTable.TARGET_INFO.Phi_Enc(1:20),0.999,0.999);
Theta_Enc_spline = calc_SmoothingCubicSpline((dataTable.TARGET_INFO.TimeEncoder(1:20)-dataTable.TARGET_INFO.TimeEncoder(1))/100000,...
    dataTable.TARGET_INFO.Theta_Enc(1:20),0.1,0.1);
Psi_Enc_spline = calc_SmoothingCubicSpline(dataTable.TARGET_INFO.TimeEncoder,...
    dataTable.TARGET_INFO.Psi_Enc,1,1);

intrpl_p = ppval(Theta_Enc_spline,EncoderTime(index+5));
plot(TimeHomeing(1:20),intrpl_p)



% TEST

% Theta_Enc_spline = calc_SmoothingCubicSpline(EncoderData.Theta_Enc(index:index+10),...
%     EncoderTime(index:index+10),1,1);



%% Extrapolate data from sensor splines

%%% Parameter
size = 10; % number of last saved samples
order = 2; % polynomial order for extrapolation
stepsize = 20; % interpolation step size [ms]
currentTime = 166452619;
t0 = currentTime; % Extrapolation timestamp
% t0 = EncoderTime(indexEnc)+15000;

indexEnc = find(EncoderTime>currentTime,1)-1;   % Find closest earlier sample index
indexAtt = find(AttTime>currentTime,1)-1;   % Find closest earlier sample index

%%%%% GIMBAL %%%%%

%%% THETA Encoder %%%

figure
tiledlayout(1,2);
nexttile;
L(1)=plot(EncoderTime(indexEnc-10:indexEnc+10)/1000000,EncoderData.Theta_Enc(indexEnc-10:indexEnc+10));
hold on
L(2)=plot(EncoderTime(indexEnc)/1000000,EncoderData.Theta_Enc(indexEnc), 'b*','MarkerSize',10);

% ThetaEncoderEval = zeros(2,size);
% Use this until smoothing works
ThetaEncoderEval = [EncoderData.Theta_Enc(indexEnc-size:indexEnc)';EncoderTime(indexEnc-size:indexEnc)'];

%%% Interpolation
ThetaEncInterp = zeros(2,order+1);
for i=1:(order+1)
    ThetaEncInterp(2,i)=EncoderTime(indexEnc)-(order+1-i)*stepsize*1000;
    ThetaEncInterp(1,i)=interp1(ThetaEncoderEval(2,:),ThetaEncoderEval(1,:),ThetaEncInterp(2,i));
end
L(3)=plot(ThetaEncInterp(2,:)/1000000,ThetaEncInterp(1,:),'g.','MarkerSize',15);

%%% Determine dividend difference table
F_ThetaEnc = calculateNewtonBackwardDividendDifference(ThetaEncInterp(2,:), ThetaEncInterp(1,:));
ThetaEncExtrapolated = evaluateNewtonPolynomial(F_ThetaEnc,ThetaEncInterp(2,:),t0);
L(4)=plot(t0/1000000,ThetaEncExtrapolated,'r*','MarkerSize',10);

hold off;
title('Theta_{Enc}');
legend(L,{'Samples', 'Most recent sample','Supporting points', 'Extrapolated'},'Location','southeast');
nexttile;



%%% PSI Encoder %%%

plot(EncoderTime(indexEnc-10:indexEnc+10)/1000000,EncoderData.Psi_Enc(indexEnc-10:indexEnc+10))
hold on
plot(EncoderTime(indexEnc)/1000000,EncoderData.Psi_Enc(indexEnc), 'b*','MarkerSize',10)

% PsiEncoderEval = zeros(2,size);
% Use this until smoothing works
PsiEncoderEval = [EncoderData.Psi_Enc(indexEnc-size:indexEnc)';EncoderTime(indexEnc-size:indexEnc)'];

%%% Interpolation
PsiEncInterp = zeros(2,order+1);
for i=1:(order+1)
    PsiEncInterp(2,i)=EncoderTime(indexEnc)-(order+1-i)*stepsize*1000;
    PsiEncInterp(1,i)=interp1(PsiEncoderEval(2,:),PsiEncoderEval(1,:),PsiEncInterp(2,i));
end
plot(PsiEncInterp(2,:)/1000000,PsiEncInterp(1,:),'g.','MarkerSize',15);

%%% Determine dividend difference table
F_PsiEnc = calculateNewtonBackwardDividendDifference(PsiEncInterp(2,:), PsiEncInterp(1,:));
PsiEncExtrapolated = evaluateNewtonPolynomial(F_PsiEnc,PsiEncInterp(2,:),t0);
plot(t0/1000000,PsiEncExtrapolated,'r*','MarkerSize',10)

hold off;
title('Psi_{Enc}');
legend(L,{'Samples', 'Most recent sample','Supporting points', 'Extrapolated'},'Location','southeast');


%%%%% IMU Attitude %%%%%

%%% PHI IMU %%%

figure
tiledlayout(1,3);
nexttile;
L(1)=plot(AttTime(indexAtt-10:indexAtt+10)/1000000,AttData.Phi(indexAtt-10:indexAtt+10));
hold on
L(2)=plot(AttTime(indexAtt)/1000000,AttData.Phi(indexAtt), 'b*','MarkerSize',10);

% ThetaAttEval = zeros(2,size);
% Use this until smoothing works
ThetaAttEval = [AttData.Phi(indexAtt-size:indexAtt)';AttTime(indexAtt-size:indexAtt)'];

%%% Interpolation
PhiIMUInterp = zeros(2,order+1);
for i=1:(order+1)
    PhiIMUInterp(2,i)=AttTime(indexAtt)-(order+1-i)*stepsize*1000;
    PhiIMUInterp(1,i)=interp1(ThetaAttEval(2,:),ThetaAttEval(1,:),PhiIMUInterp(2,i));
end
L(3)=plot(PhiIMUInterp(2,:)/1000000,PhiIMUInterp(1,:),'g.','MarkerSize',15);

%%% Determine dividend difference table
F_PhiIMU = calculateNewtonBackwardDividendDifference(PhiIMUInterp(2,:), PhiIMUInterp(1,:));
PhiIMUExtrapolated = evaluateNewtonPolynomial(F_PhiIMU,PhiIMUInterp(2,:),t0);
L(4)=plot(t0/1000000,PhiIMUExtrapolated,'r*','MarkerSize',10);

hold off;
title('Phi_{Att}');
legend(L,{'Samples', 'Most recent sample','Supporting points', 'Extrapolated'},'Location','southeast');
nexttile;


%%% THETA IMU %%%

plot(AttTime(indexAtt-10:indexAtt+10)/1000000,AttData.Theta(indexAtt-10:indexAtt+10))
hold on
plot(AttTime(indexAtt)/1000000,AttData.Theta(indexAtt), 'b*','MarkerSize',10)

% ThetaAttEval = zeros(2,size);
% Use this until smoothing works
ThetaAttEval = [AttData.Theta(indexAtt-size:indexAtt)';AttTime(indexAtt-size:indexAtt)'];

%%% Interpolation
ThetaIMUInterp = zeros(2,order+1);
for i=1:(order+1)
    ThetaIMUInterp(2,i)=AttTime(indexAtt)-(order+1-i)*stepsize*1000;
    ThetaIMUInterp(1,i)=interp1(ThetaAttEval(2,:),ThetaAttEval(1,:),ThetaIMUInterp(2,i));
end
plot(ThetaIMUInterp(2,:)/1000000,ThetaIMUInterp(1,:),'g.','MarkerSize',15);

%%% Determine dividend difference table
F_ThetaIMU = calculateNewtonBackwardDividendDifference(ThetaIMUInterp(2,:), ThetaIMUInterp(1,:));
ThetaIMUExtrapolated = evaluateNewtonPolynomial(F_ThetaIMU,ThetaIMUInterp(2,:),t0);
plot(t0/1000000,ThetaIMUExtrapolated,'r*','MarkerSize',10)

hold off;
title('Theta_{Att}');
legend(L,{'Samples', 'Most recent sample','Supporting points', 'Extrapolated'},'Location','southeast');
nexttile;

%%% PSI IMU %%%

plot(AttTime(indexAtt-10:indexAtt+10)/1000000,AttData.Psi(indexAtt-10:indexAtt+10))
hold on
plot(AttTime(indexAtt)/1000000,AttData.Psi(indexAtt), 'b*','MarkerSize',10)

% ThetaAttEval = zeros(2,size);
% Use this until smoothing works
ThetaAttEval = [AttData.Psi(indexAtt-size:indexAtt)';AttTime(indexAtt-size:indexAtt)'];

%%% Interpolation
PsiIMUInterp = zeros(2,order+1);
for i=1:(order+1)
    PsiIMUInterp(2,i)=AttTime(indexAtt)-(order+1-i)*stepsize*1000;
    PsiIMUInterp(1,i)=interp1(ThetaAttEval(2,:),ThetaAttEval(1,:),PsiIMUInterp(2,i));
end
plot(PsiIMUInterp(2,:)/1000000,PsiIMUInterp(1,:),'g.','MarkerSize',15);

%%% Determine dividend difference table
F_PsiIMU = calculateNewtonBackwardDividendDifference(PsiIMUInterp(2,:), PsiIMUInterp(1,:));
PsiIMUExtrapolated = evaluateNewtonPolynomial(F_PsiIMU,PsiIMUInterp(2,:),t0);
plot(t0/1000000,PsiIMUExtrapolated,'r*','MarkerSize',10)

hold off;
title('Psi_{Att}');
legend(L,{'Samples', 'Most recent sample','Supporting points', 'Extrapolated'},'Location','southeast');



