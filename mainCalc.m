function [cornerM, stiff, freq, sblock] = mainCalc(var)
    
% Var is the vehicle configuration     

% Stiffness calculations
    
    % Mass % mass of the vehicle times the distribution of the weight 
    cornerM.total_ft = var.M*var.distWeight_ft/2; % N on ft
    cornerM.total_rr = var.M*(1-var.distWeight_ft)/2; % N on r
    
    cornerM.sprung_ft = var.sprungM*var.distSprungW_ft/2; 
    cornerM.sprung_rr = var.sprungM*(1-var.distSprungW_ft)/2;
    
    cornerM.unsprung_ft = var.unsprungM*var.distUnsprungW_ft/2;
    cornerM.unsprung_rr = var.unsprungM*(1-var.distUnsprungW_ft)/2;

  


    % Stiffness  get the roll stiffness of the springs and the rollrate 
    stiff=struct();
    stiff.WRmainSpring_ft = var.RS_Spring_ft/(var.MR_ft^2);  % Spring rate / Motion ratio Squared
    stiff.WRmainSpring_rr = var.RS_Spring_rr/(var.MR_rr^2);
    
    stiff.WRtotal_ft = (stiff.WRmainSpring_ft*var.Kt)/(stiff.WRmainSpring_ft+var.Kt);
    stiff.WRtotal_rr = (stiff.WRmainSpring_rr*var.Kt)/(stiff.WRmainSpring_rr+var.Kt);
    
    stiff.rollRateSprings_ft = 0.5*stiff.WRmainSpring_ft*var.Tr_ft^2;  % Nm/rad
    stiff.rollRateSprings_rr = 0.5*stiff.WRmainSpring_rr*var.Tr_rr^2;  % Nm/rad
    
    stiff.rollRateTyres_ft = var.Kt*var.Tr_ft^2;
    stiff.rollRateTyres_rr = var.Kt*var.Tr_rr^2;
    
    stiff.rollRateARB_ft = var.RS_ARB_ft/(var.MR_ARB_ft^2);  % Nm/rad
    stiff.rollRateARB_rr = var.RS_ARB_rr/(var.MR_ARB_rr^2);  % Nm/rad
    
    stiff.rollRateSpringsTyresARB_ft = (stiff.rollRateTyres_ft*(stiff.rollRateSprings_ft+stiff.rollRateARB_ft))/(stiff.rollRateSprings_ft+stiff.rollRateTyres_ft+stiff.rollRateARB_ft);
    stiff.rollRateSpringsTyresARB_rr = (stiff.rollRateTyres_rr*(stiff.rollRateSprings_rr+stiff.rollRateARB_rr))/(stiff.rollRateSprings_rr+stiff.rollRateTyres_rr+stiff.rollRateARB_rr);
    
    stiff.rollRateSpringsARB_ft = stiff.rollRateSprings_ft + stiff.rollRateARB_ft;
    stiff.rollRateSpringsARB_rr = stiff.rollRateSprings_rr + stiff.rollRateARB_rr;
    
    stiff.pitchRate = 2*var.WB^2*(stiff.WRtotal_ft*stiff.WRtotal_rr)/(stiff.WRtotal_ft+stiff.WRtotal_rr); % Pitch rate is calculated herea and on susCalc
    
    stiff.heaveRate = 2*stiff.WRtotal_ft + 2*stiff.WRtotal_rr;  
    
    
    
    % Frequencies
    freq.sprungM_NFreq_ft = sqrt(stiff.WRtotal_ft/cornerM.sprung_ft)/(2*pi);
    freq.sprungM_NFreq_rr = sqrt(stiff.WRtotal_rr/cornerM.sprung_rr)/(2*pi);
    
    freq.unsprungM_NFreq_ft = sqrt(stiff.WRtotal_ft/cornerM.unsprung_ft)/(2*pi);
    freq.unsprungM_NFreq_rr = sqrt(stiff.WRtotal_rr/cornerM.unsprung_rr)/(2*pi);
    
    freq.total_NFreq_ft = sqrt(stiff.WRtotal_ft/cornerM.total_ft)/(2*pi);
    freq.total_NFreq_rr = sqrt(stiff.WRtotal_rr/cornerM.total_rr)/(2*pi);
    
    freq.pitch_NFreq =sqrt(stiff.pitchRate/var.Pitch_inertia)/(2*pi);
    freq.roll_NFreq = sqrt(stiff.rollRateSprings_ft/var.Roll_inertia)/(2*pi);
    
    freq.sprungM_CDamp_ft = 4*cornerM.sprung_ft*freq.sprungM_NFreq_ft*pi;
    freq.sprungM_CDamp_rr = 4*cornerM.sprung_rr*freq.sprungM_NFreq_rr*pi;
    
    freq.unsprungM_CDamp_ft = 4*cornerM.unsprung_ft*freq.unsprungM_NFreq_ft*pi;
    freq.unsprungM_CDamp_rr = 4*cornerM.unsprung_rr*freq.unsprungM_NFreq_rr*pi;
    
    freq.pitchCDamp = 2*sqrt(stiff.pitchRate*var.Pitch_inertia);
    
    freq.rollCDamp = 2*sqrt((stiff.rollRateSprings_ft+stiff.rollRateSprings_rr)*var.Roll_inertia);
    
    
    
    % Spring block calculations
    sblock.tenderMainStiff_ft = (var.RS_Spring_ft*var.Stiff_Tspring_ft)/(var.RS_Spring_ft+var.Stiff_Tspring_ft);
    sblock.tenderMainStiff_rr = (var.RS_Spring_rr*var.Stiff_Tspring_rr)/(var.RS_Spring_rr+var.Stiff_Tspring_rr);
    
    sblock.staticFSpring_ft = (cornerM.total_ft*var.g)/var.MR_ft;
    sblock.staticFSpring_rr = (cornerM.total_rr*var.g)/var.MR_rr;
    
    sblock.minStaticFDeflDamper_ft = 0.025/var.MR_ft;
    sblock.minStaticFDeflDamper_rr = 0.025/var.MR_rr;
    
    sblock.deflTBlock_onDamper_TMain_ft = var.F_TenderBlock_ft/sblock.tenderMainStiff_ft;
    sblock.deflTBlock_onDamper_TMain_rr = var.F_TenderBlock_rr/sblock.tenderMainStiff_rr;
    
    sblock.deflTBlock_onDamper_Main_ft = (sblock.staticFSpring_ft-var.F_TenderBlock_ft)/var.RS_Spring_ft;
    sblock.deflTBlock_onDamper_Main_rr = (sblock.staticFSpring_rr-var.F_TenderBlock_rr)/var.RS_Spring_rr;
    
    sblock.deflTotal_onDamper_ft = sblock.deflTBlock_onDamper_Main_ft + sblock.deflTBlock_onDamper_TMain_ft;
    sblock.deflTotal_onDamper_rr = sblock.deflTBlock_onDamper_Main_rr + sblock.deflTBlock_onDamper_TMain_rr;
    
    sblock.deflT_onWheel_ft = sblock.deflTotal_onDamper_ft * var.MR_ft;
    sblock.deflT_onWheel_rr = sblock.deflTotal_onDamper_rr * var.MR_rr;
    
    % sblock.preLoadDist_ft = (sblock.staticFSpring_ft-var.F_TenderBlock_ft)/var.Stiff_MSpring_ft-sblock.minStaticFDeflDamper_ft+sblock.deflTBlock_onDamper_TMain_ft;
    % sblock.preLoadDist_rr = (sblock.staticFSpring_rr-var.F_TenderBlock_rr)/var.Stiff_MSpring_rr-sblock.minStaticFDeflDamper_rr+sblock.deflTBlock_onDamper_TMain_rr;
    % 
    % sblock.preLoadForce_ft = sblock.tenderMainStiff_ft * sblock.preLoadDist_ft;
    % sblock.preLoadForce_rr = sblock.tenderMainStiff_rr * sblock.preLoadDist_rr;
    
    sblock.preLoadForce_ft = (sblock.minStaticFDeflDamper_ft * var.RS_Spring_ft + sblock.deflTBlock_onDamper_TMain_ft * (sblock.tenderMainStiff_ft-var.RS_Spring_ft)-sblock.staticFSpring_ft)/(1-var.RS_Spring_ft/sblock.tenderMainStiff_ft);
    sblock.preLoadForce_rr = (sblock.minStaticFDeflDamper_rr * var.RS_Spring_rr + sblock.deflTBlock_onDamper_TMain_rr * (sblock.tenderMainStiff_rr-var.RS_Spring_rr)-sblock.staticFSpring_rr)/(1-var.RS_Spring_rr/sblock.tenderMainStiff_rr);
    
    sblock.preLoadDistance_ft = sblock.preLoadForce_ft / sblock.tenderMainStiff_ft;
    sblock.preLoadDistance_rr = sblock.preLoadForce_rr / sblock.tenderMainStiff_rr;
    
    sblock.staticDeflTot_onDamper_wPreLoad_ft = (var.F_TenderBlock_ft-sblock.preLoadForce_ft)/sblock.tenderMainStiff_ft+(sblock.staticFSpring_ft-(var.F_TenderBlock_ft-sblock.preLoadForce_ft))/var.RS_Spring_ft;
    sblock.staticDeflTot_onDamper_wPreLoad_rr = (var.F_TenderBlock_rr-sblock.preLoadForce_rr)/sblock.tenderMainStiff_rr+(sblock.staticFSpring_rr-(var.F_TenderBlock_rr-sblock.preLoadForce_rr))/var.RS_Spring_rr;
    
    sblock.staticDeflTot_onWheel_wPreLoad_ft = sblock.staticDeflTot_onDamper_wPreLoad_ft*var.MR_ft;
    sblock.staticDeflTot_onWheel_wPreLoad_rr = sblock.staticDeflTot_onDamper_wPreLoad_rr*var.MR_rr;
    
    sblock.springDroopMaxMov_ft = sblock.minStaticFDeflDamper_ft;
    sblock.springDroopMaxMov_rr = sblock.minStaticFDeflDamper_rr;
    
    sblock.springBumpMaxMov_ft = var.Damper_stroke_ft - sblock.springDroopMaxMov_ft;
    sblock.springBumpMaxMov_rr = var.Damper_stroke_rr - sblock.springDroopMaxMov_rr;
    
    sblock.wheelDroopMov_ft = sblock.springDroopMaxMov_ft * var.MR_ft;
    sblock.wheelDroopMov_rr = sblock.springDroopMaxMov_rr * var.MR_rr;
    
    sblock.wheelBumpMov_ft = sblock.springBumpMaxMov_ft * var.MR_ft;
    sblock.wheelBumpMov_rr = sblock.springBumpMaxMov_rr * var.MR_rr;

%     if sblock.wheelDroopMov_ft < 0.025 || sblock.wheelDroopMov_rr < 0.025 || sblock.wheelBumpMov_ft < 0.025 || sblock.wheelBumpMov_rr < 0.025
%         disp('Wheel droop smaller than allowed by the rules')
    end