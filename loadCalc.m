function [longLT,usLatLT_ft,usLatLT_rr,geomLatLT_ft,geomLatLT_rr,elasticLatLT_ft,elasticLatLT_rr] = ...
                                                            loadCalc(carParams,ax,ay,RA,RSD,TRS)

    % calc_LoadTransfers    Calculates load transfers from given car acceleration components, as
    % TRS is the total roll stiffness and the RSD is the Roll stiffness
    % distribution 
    % ax is the longitudinal accelration 

    % Left -> Inner
    % Right -> Outer
    
    %      Front
    % FL \\------\\ FR
    %        ||
    %  Left/ || Right/
    %  Inner || Outer
    %        ||
    % RL ||------|| RR
    %       Rear
    
    arguments
        carParams
        ax
        ay 
        RA
        RSD
        TRS
    end
    
    p = carParams;
    
    M   = p.M; 
    hCG = p.hCG;
    WB  = p.WB;
    a   = p.a;
    b   = p.b;
    K_roll_ft= RSD*TRS; 
    K_roll_rr = (1-RSD)*TRS; 
    roll_Angle= RA;

    ay=ay*9.81;  % the input accelration is in G-units


    
    %% Load Transfers

    if ay ~= 0

        Tr_ft = p.Tr_ft;
        Tr_rr = p.Tr_rr;

        hRC_rr = p.hRC_rr;
        hRC_ft = p.hRC_ft;
            
        sprungM = p.sprungM;
        unsprungM = p.unsprungM;
        unsprung_hCG = p.unsprung_hCG;
        sprung_hCG = p.sprung_hCG;
        distUnsprungW_ft = p.distUnsprungW_ft;
        distUnsprungW_rr = (1-distUnsprungW_ft);
        distSprungW_ft = p.distSprungW_ft;
        distSprungW_rr = (1-distSprungW_ft);
        
        RS_ft  = carParams.RS_ft; % Front total roll stiffness
        RS_rr  = carParams.RS_rr; % Rear total roll stiffness
        
        rollAxisSlope = atan((hRC_rr - hRC_ft)/WB);
        RollAxisUnderCG = hRC_ft + rollAxisSlope*a;
        dH = sprung_hCG - RollAxisUnderCG;
        fracRS_ft = RS_ft/(RS_ft+RS_rr);
        fracRS_rr = RS_rr/(RS_ft+RS_rr);
        
        % Rouelle Formulas
        usLatLT_ft = (distUnsprungW_ft * unsprungM * ay * unsprung_hCG)/Tr_ft;
        usLatLT_rr = (distUnsprungW_rr * unsprungM * ay * unsprung_hCG)/Tr_rr;


     

        % Geometric Load Transfer
         geomLatLT_ft = (distSprungW_ft * sprungM * ay * hRC_ft)/Tr_ft; % depend only on the height of the roll center
    
        geomLatLT_rr = (distSprungW_rr * sprungM * ay * hRC_rr)/Tr_rr;

% OLD funciton
%         elasticLatLT_ft = (distSprungW_ft * sprungM * ay * dH * fracRS_ft)/Tr_ft;
%         elasticLatLT_rr = (distSprungW_rr * sprungM * ay * dH * fracRS_rr)/Tr_rr;

% NEW take into account the roll stiffnnes and the effect of the springs 

    elasticLatLT_ft=(roll_Angle*K_roll_ft)/Tr_ft;
    elasticLatLT_rr=(roll_Angle*K_roll_rr)/Tr_rr;

    delta_Ft=elasticLatLT_ft+geomLatLT_ft+usLatLT_ft;
       
        % Milliken Formulas
%         rollAxisSlope = atan((hRC_rr - hRC_ft)/WB); % check Miliken (p.681) % added atan to formula
%         RollAxisUnderCG = hRC_ft + rollAxisSlope*a;
%         dH = hCG - RollAxisUnderCG;                 % vertical distance between CG and Roll Axis
%         frontLatLT = ay*M/Tr_ft*(dH*RS_ft/(RS_ft+RS_rr) + b/WB*hRC_ft);
%         rearLatLT = ay*M/Tr_rr*(dH*RS_rr/(RS_ft+RS_rr) + a/WB*hRC_rr);
        



        %lateral Load Transfer Distribution


    else
        
        usLatLT_ft = 0;
        usLatLT_rr = 0;
        geomLatLT_ft = 0;
        geomLatLT_rr = 0;
        elasticLatLT_ft = 0;
        elasticLatLT_rr = 0;
        
%         frontLatLT = 0;
%         rearLatLT = 0;
    
    end
    
    longLT = M*hCG*ax/WB;

end