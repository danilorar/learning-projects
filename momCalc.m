function  [pitchMom,rollMom]  = momCalc(latG, lonG, var)
   

    hRC_pos_rr=var.hRC_ft; 
    hRC_pos_ft=var.hRC_rr;
    hPC_pos=var.hPC;
    % Dynamic loads
%     Fz = vdl_calc_Loads(var,[],[],lonG,latG,v);
%     if any(Fz < 0)
%         disp('One wheel is is the air! Calculations are false!')
%     end


    % Roll moment
   
    zDist_CMCG_rollAxis = var.sprung_hCG-(((hRC_pos_rr - hRC_pos_ft)/var.WB*(((1-var.distSprungW_ft)*100)/100*var.WB))+ hRC_pos_ft); 
    rollMom = var.sprungM*var.g*latG*zDist_CMCG_rollAxis;
   
    % Pitch moment
    pitchMom = lonG*var.g*var.sprungM*(var.sprung_hCG - hPC_pos); 


 



