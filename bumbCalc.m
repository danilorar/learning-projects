function bumbCalc(CAR,velocity )

% CAR is the base vehicle struct that stores all the vehicle data refer to
% the read me to understand more 

 if nargin < 2
        velocity = 60; % Default value in mph
 end


%% bump oscillation profile at half load
percF=CAR.distWeight_ft; % the percentage for the front weight 
ms=CAR.sprungM; 
mus=CAR.unsprungM; 
%weights in kg per corner
Ws_front = percF*ms;
Ws_rear = (1-percF)*ms;
Wu_front = percF*mus;
Wu_rear = (1-percF)*mus;

WB = CAR.WB;  %wheel base in mm
V = velocity;   %speed of vheicle in mph

%motion ratios(average values are used to reduce th amount of data points) 
MR_f = CAR.MR_ft;
MR_r = CAR.MR_rr;

%time lag in sec
tl = (WB*(10^(-3)))/(60*(0.447));

%recommended natural frequencies at half load
fs_front = 1.15;
fs_rear = 1/((1/fs_front)-tl);

%rates in N/mm
%tire rate (same for all)
kt = CAR.Kt;

%ride rates
kr_front = (((fs_front*2*pi)^2)*(Ws_front))/1000;
kr_rear = (((fs_rear*2*pi)^2)*(Ws_rear))/1000;

%wheel rates
kw_front = (kt*kr_front)/(kt-kr_front);
kw_rear = (kt*kr_rear)/(kt-kr_rear);

%spring rates
ks_front = kw_front/(MR_f)^2;
ks_rear = kw_rear/(MR_r)^2;

%unsprung mass frequencies
fu_front = (1/(2*pi))*((kw_front+kt)*1000/Wu_front)^0.5;
fu_rear = (1/(2*pi))*((kw_rear+kt)*1000/Wu_rear)^0.5;

%plotting the graphs
%time range in sec
time = linspace(0,3.5,400);

i = 1;
for t = linspace(0,3.5,400)
    As_front(i) = exp(-t)*sin(2*pi*fs_front*t);
    As_rear(i) = exp(-t)*sin(2*pi*fs_rear*(t-tl));
    Au_front(i) = exp(-t)*sin(2*pi*fu_front*t);
    Au_rear(i) = exp(-t)*sin(2*pi*fu_rear*(t-tl));
    i=i+1;
end

figure(1)
subplot(2,1,1)
plot(time,As_front,'linewidth',2)
hold on
plot(time,As_rear,'linewidth',2)
title('Bump oscillation profile for Sprung mass at half load')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on

subplot(2,1,2)
plot(time,Au_front,'linewidth',2)
hold on
plot(time,Au_rear,'linewidth',2)
title('Bump oscillation profile for Unsprung mass')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on




%% bump oscillation profile at curb

%weights in kg per corner
Wsc_front = 405;
Wsc_rear = 270;
Wuc_front = 45;
Wuc_rear = 30;

%motion ratios
MR_f = 0.97;
MR_r = 0.85;

%spring rates
ksc_front = ks_front;
ksc_rear = ks_rear;

%wheel rates
kwc_front = ksc_front*(MR_f)^2;
kwc_rear = ksc_rear*(MR_r)^2;

%ride rates
krc_front = (kt*kwc_front)/(kt+kwc_front);
krc_rear = (kt*kwc_rear)/(kt+kwc_rear);

%sprung mass frequencies
fsc_front = (1/(2*pi))*((krc_front*1000)/Wsc_front)^0.5;
fsc_rear = (1/(2*pi))*((krc_rear*1000)/Wsc_rear)^0.5;

%unsprung mass frequencies
fuc_front = (1/(2*pi))*((kwc_front+kt)*1000/Wuc_front)^0.5;
fuc_rear = (1/(2*pi))*((kwc_rear+kt)*1000/Wuc_rear)^0.5;

%plotting the graphs
%time range in sec
time = linspace(0,3.5,400);

j = 1;
for tc = linspace(0,3.5,400)
    Asc_front(j) = exp(-tc)*sin(2*pi*fsc_front*tc);
    Asc_rear(j) = exp(-tc)*sin(2*pi*fsc_rear*(tc-tl));
    Auc_front(j) = exp(-tc)*sin(2*pi*fuc_front*tc);
    Auc_rear(j) = exp(-tc)*sin(2*pi*fuc_rear*(tc-tl));
    j=j+1;
end

figure(2)
subplot(2,1,1)
plot(time,Asc_front,'linewidth',2,'color','red')
hold on
plot(time,Asc_rear,'linewidth',2,'color','yellow')
title('Bump oscillation profile for Sprung mass at curb')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on

subplot(2,1,2)
plot(time,Auc_front,'linewidth',2,'color','red')
hold on
plot(time,Auc_rear,'linewidth',2,'color','yellow')
title('Bump oscillation profile for Unsprung mass')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on




%% bump oscillation profile at GVW 

%weights in kg per corner
Wsg_front = 475;
Wsg_rear = 450;
Wug_front = 45;
Wug_rear = 30;

%motion ratios
MR_f = 0.97;
MR_r = 0.85;

%spring rates
ksg_front = ks_front;
ksg_rear = ks_rear;

%wheel rates
kwg_front = ksg_front*(MR_f)^2;
kwg_rear = ksg_rear*(MR_r)^2;

%ride rates
krg_front = (kt*kwg_front)/(kt+kwg_front);
krg_rear = (kt*kwg_rear)/(kt+kwg_rear);

%sprung mass frequencies
fsg_front = (1/(2*pi))*((krg_front*1000)/Wsg_front)^0.5;
fsg_rear = (1/(2*pi))*((krg_rear*1000)/Wsg_rear)^0.5;

%unsprung mass frequencies
fug_front = (1/(2*pi))*((kwg_front+kt)*1000/Wug_front)^0.5;
fug_rear = (1/(2*pi))*((kwg_rear+kt)*1000/Wug_rear)^0.5;

%plotting the graphs
%time range in sec
time = linspace(0,3.5,400);

k = 1;
for tg = linspace(0,3.5,400)
    Asg_front(k) = exp(-tg)*sin(2*pi*fsg_front*tg);
    Asg_rear(k) = exp(-tg)*sin(2*pi*fsg_rear*(tg-tl));
    Aug_front(k) = exp(-tg)*sin(2*pi*fug_front*tg);
    Aug_rear(k) = exp(-tg)*sin(2*pi*fug_rear*(tg-tl));
    k=k+1;
end

figure(3)
subplot(2,1,1)
plot(time,Asg_front,'linewidth',2,'color','blue')
hold on
plot(time,Asg_rear,'linewidth',2,'color','green')
title('Bump oscillation profile for Sprung mass at GVW')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on

subplot(2,1,2)
plot(time,Aug_front,'linewidth',2,'color','blue')
hold on
plot(time,Aug_rear,'linewidth',2,'color','green')
title('Bump oscillation profile for Unsprung mass')
xlabel('Time (s)')
ylabel('Amplitude (m)')
legend('Front','Rear')
grid on


end 