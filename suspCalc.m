function [ pitchRate, pitchAngle, totalRollStiff, rollAngle, mechBalance,NF_f,NF_r,HR, WR_r , WR_f] = suspCalc( rollMom, pitchMom, vehicleConfig);

% 



ARB_ft.Stiff=vehicleConfig.RS_ARB_ft;
ARB_rr.Stiff=vehicleConfig.RS_ARB_rr;

ARB_ft.MR=vehicleConfig.MR_ARB_ft;
ARB_rr.MR=vehicleConfig.MR_ARB_rr;

Spring_ft = struct(); 
Spring_rr = struct();

Spring_ft.Stiff =vehicleConfig.RS_Spring_ft;
Spring_rr.Stiff=vehicleConfig.RS_Spring_rr;

Spring_ft.MR = vehicleConfig.MR_ft; 
Spring_rr.MR = vehicleConfig.MR_rr; 


L=vehicleConfig.WB;

hPC=struct();

hPC.fpos = vehicleConfig.PCx_ft;
hPC.rpos = vehicleConfig.PCx_rr;

%% Weight of the vehicle 
    % Mass % mass of the vehicle times the distribution of the weight 
    cornerM.total_ft = vehicleConfig.M*vehicleConfig.distWeight_ft/2; % N on ft
    cornerM.total_rr = vehicleConfig.M*(1-vehicleConfig.distWeight_ft)/2; % N on r
    
    cornerM.sprung_ft = vehicleConfig.sprungM*vehicleConfig.distSprungW_ft/2; 
    cornerM.sprung_rr = vehicleConfig.sprungM*(1-vehicleConfig.distSprungW_ft)/2;
    
    cornerM.unsprung_ft = vehicleConfig.unsprungM*vehicleConfig.distUnsprungW_ft/2;
    cornerM.unsprung_rr = vehicleConfig.unsprungM*(1-vehicleConfig.distUnsprungW_ft)/2;


%%
    ARB_ft.Stiff= ARB_ft.Stiff / ARB_ft.MR.^2; % Stiffness of the anti-roll bar fRont 
    ARB_rr.Stiff = ARB_rr.Stiff/ARB_rr.MR.^2; % Stiffness of the anti-roll bar  Rear
    ARB_ft.Stiff(isinf(ARB_ft.Stiff)) = 0; 
    ARB_rr.Stiff(isinf(ARB_rr.Stiff)) = 0;

 %% 
    Spring_ft.WR = (Spring_ft.Stiff./(Spring_ft.MR.^2).*vehicleConfig.Kt)./(Spring_ft.Stiff/(Spring_rr.MR.^2)+vehicleConfig.Kt); % FEITO 
    Spring_ft.RollRate = 0.5.*Spring_ft.Stiff./Spring_ft.MR.^2.*vehicleConfig.Tr_ft.^2; 


    
    Spring_rr.WR = (Spring_rr.Stiff./(Spring_rr.MR.^2).*vehicleConfig.Kt)./(Spring_rr.Stiff/(Spring_rr.MR.^2)+vehicleConfig.Kt); % FEITO 
    Spring_rr.RollRate = 0.5.*Spring_rr.Stiff./Spring_rr.MR.^2.*vehicleConfig.Tr_rr.^2; 

    
%%    % PITCH 
    [WR_ft,WR_rr] =  meshgrid(Spring_ft.WR, Spring_rr.WR);
    
    pitchStiff= (Spring_ft.Stiff*Spring_rr.Stiff*L^2)/(Spring_ft.Stiff+Spring_rr.Stiff);

   
    % th epitch rate isupposedly taking the spring into account 
    pitchRate = (hPC.fpos.*(2.*WR_ft)+(L-hPC.fpos).*(2.*WR_rr)); % FEITO 
    pitchAngle = pitchMom./pitchRate;  

    pitchRate = pitchRate * pi/180; % Nm/rad ? 
    pitchAngle = pitchAngle * 180/pi; % deg 
    

    % ROLL
    totalStiff_ft = vehicleConfig.RollStiff*(Spring_ft.RollRate + ARB_ft.Stiff)./(vehicleConfig.RollStiff+ Spring_ft.RollRate + ARB_ft.Stiff);
    totalStiff_rr = vehicleConfig.RollStiff*(Spring_rr.RollRate + ARB_rr.Stiff)./(vehicleConfig.RollStiff+ Spring_rr.RollRate + ARB_rr.Stiff); 
    
    [totStiff_rr,totStiff_ft] =  meshgrid(totalStiff_rr, totalStiff_ft); 
    
    totalRollStiff = totStiff_ft + totStiff_rr;
    totalRollStiff_rad=totalRollStiff*(pi/180); 
    rollAngle = rollMom./totalRollStiff_rad;
    mechBalance = totStiff_ft./(totStiff_ft+totStiff_rr); % is the  roll stiffness distribution



    %%  % Natural Frequency 

    NF_f = sqrt(Spring_ft.WR/cornerM.sprung_ft)/(2*pi);
   
    NF_r = sqrt(Spring_rr.WR/cornerM.sprung_rr)/(2*pi);


   HR = 2*Spring_rr.WR+ 2*Spring_ft.WR;  
    
WR_f=Spring_ft.WR; 
WR_r=Spring_rr.WR; 

    