function dampCalc(CAR)
%DAMPCALC Summary of this function goes here
%   Detailed explanation goes here


%% inputs

percF=CAR.distWeight_ft; % the percentage for the front weight 
ms=CAR.sprungM; 
mus=CAR.unsprungM; 


%weights in kg/corner 
Ws_f = percF*ms;       %front sprung
Ws_r = (1-percF)*ms;       %rear sprung
Wu_f = percF*mus;      %front unsprung
Wu_r = (1-percF)*mus;      %rear unsprung

%damping ratios
ds_f = 0.70;        %front
ds_r = 0.70;        %rear
du_f = 0.20;        %front
du_r = 0.20;        %rear

%rebound/compression ratio
r_f = 1.3;     %front
r_r = 1.3;     %rear

%motion ratio
MR_f = CAR.MR_ft;        %front
MR_r = CAR.MR_rr;        %rear

%rates
%spring rates in N/mm
ks_f = CAR.RS_Spring_ft;      %front
ks_r = CAR.RS_Spring_rr;      %rear

%tire rates in N/mm
kt_f = CAR.Kt;     %front
kt_r = CAR.Kt;     %rear

%wheel rates in N/mm
kw_f = CAR.WR_ft;       %front
kw_r = CAR.WR_rr;       %rear

%ride rates in N/mm
kr_f = (kw_f*kt_f)/(kw_f+kt_f);     %front
kr_r = (kw_r*kt_r)/(kw_r+kt_r);     %rear


%% determination of required parameters

%critical damping in Ns/m
cds_f = 2*(kr_f*Ws_f*1000)^0.5;          %for front sprung mass 
cds_r = 2*(kr_r*Ws_r*1000)^0.5;          %for rear sprung mass
cdu_f = 2*((kw_f+kt_f)*1000*Wu_f)^0.5;   %for front unsprung mass
cdu_r = 2*((kw_r+kt_r)*1000*Wu_r)^0.5;   %for rear unsprung mass

%damping coefficient in Ns/m
Cs_f = ds_f*cds_f;      %for front sprung mass
Cs_r = ds_r*cds_r;      %for rear sprung mass
Cu_f = du_f*cdu_f;      %for front unsprung mass
Cu_r = du_r*cdu_r;      %for rear unsprung mass

%compression damping in Ns/m
dclo_f = Cs_f/2;        %low speed compression damping for front
dclo_r = Cs_r/2;        %low speed compression damping for rear
dchi_f = Cu_f/2;        %high speed compression damping for front
dchi_r = Cu_r/2;        %high speed compression damping for rear

%rebound damping in Ns/m
drlo_f = dclo_f*r_f;        %low speed rebound damping for front
drlo_r = dclo_r*r_r;        %low speed rebound damping for rear
drhi_f = dchi_f*r_f;        %high speed rebound damping for front
drhi_r = dchi_r*r_r;        %high speed rebound damping for rear


%% plotting Force vs Velocity shock curve

%velocity in mm/s
V = linspace(0,500,501);

%front shock

i = 1;
for v = linspace(0,500,501)
    if V(i) <= 50
        Fc(i) = dclo_f*V(i)/1000;
        Fr(i) = -drlo_f*V(i)/1000;
    else
        Fc(i) = Fc(i-1)+(V(i)-V(i-1))*dchi_f/1000;
        Fr(i) = Fr(i-1)-(V(i)-V(i-1))*drhi_f/1000;
    end
    i=i+1;
end

figure(1)
hold on
plot(V,Fc,'linewidth',2,'color','b')
plot(V,Fr,'linewidth',2,'color','g')
plot([0 500], [0 0],'color','black')
xlabel('Damping Velocity (mm/s)')
ylabel('Fornce (N)')
title('Front shock - Force v/s Velocity')
legend('Compresion Force','Rebound force','location','southwest')
grid on

saveas(1,'front_shock','jpeg')


%rear shock

j = 1;
for v = linspace(0,500,501)
    if V(j) <= 50
        Fc2(j) = dclo_r*V(j)/1000;
        Fr2(j) = -drlo_r*V(j)/1000;
    else
        Fc2(j) = Fc2(j-1)+(V(j)-V(j-1))*dchi_r/1000;
        Fr2(j) = Fr2(j-1)-(V(j)-V(j-1))*drhi_r/1000;
    end
    j=j+1;
end

figure(2)
hold on
plot(V,Fc2,'linewidth',2,'color','b')
plot(V,Fr2,'linewidth',2,'color','g')
plot([0 500], [0 0],'color','black')
xlabel('Damping Velocity (mm/s)')
ylabel('Fornce (N)')
title('Rear shock - Force v/s Velocity')
legend('Compresion Force','Rebound force','location','southwest')
grid on

