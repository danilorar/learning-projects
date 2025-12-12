function [wheel_loads] = ImpCalc(veh,ax,ay,RA,RSD,TRS)

% the weight transfer function to the wheels
% ax is the positive accelration 
% Raduis og tur


m=veh.M; 
Tr_rr = veh.Tr_rr;
Tr_ft = veh.Tr_ft;

K_roll_ft=TRS*RSD; ; %Nm/ rad 
K_roll_RR=TRS*(1-RSD); % Nm / rad 

RA=RA*pi/180; % rad

w=m*9.81; % the weight of the vehicle 

wf=w*veh.distWeight_ft; 
wr=w*1-wf; 

a=veh.a; 
b=veh.b;

L=a+b; % wheel base 

% weight transfer effect 

LTE_X = m*ax*hCG /L ;   % N 
 
LTE_Y_f = ay*hCG/veh.Tr_ft ; % N

LTE_Y_r=ay*hCG/veh.Tr_rr ;  % N 


 eLT_ft = (RA*K_roll_ft)/Tr_ft; % elastic laod trasnfer due to the spring stiffness and the roll angle

 eLT_rr = (RA*K_roll_rr)/Tr_rr; % elastic load transfer


 LTE_Y_r = LTE_Y_r+eLT_rr; % lateral load transfer taking into account the effect of the roll 
 LTE_Y_f = LTE_Y_r+eLT_ft;

 LTE_X
 LTE_X

loads= [
    
(wr-LTE_X-LTE_Y_f)/2    , (wr-LTE_X+LTE_Y_f)/2
(wr+LTE_X-LTE_Y_r)/2    , (wr+LTE_X+LTE_Y_r)/2 

]; 


wheel_loads.outerFront =loads(2); 
wheel_loads.innerFront =loads(1); 
wheel_loads.outerRear= loads (3); 
wheel_loads.innerRear=loads(4); 
end

