function Anti_Force = ComputeAntiForces(Kinematics, TireForces, Car)

Anti_Force.FO = TireForces.FO.x*(Kinematics.PCO_z/...
    (Kinematics.PCO_x-Kinematics.FrontContactPatchOuterX));

Anti_Force.FI = TireForces.FI.x*(Kinematics.PCI_z/...
    (Kinematics.PCI_x-Kinematics.FrontContactPatchInnerX));

Anti_Force.RO = TireForces.RO.x*(Kinematics.PCO_z/(Kinematics.PCO_x-(-Car.wb)));

Anti_Force.RI = TireForces.RI.y*(Kinematics.PCI_z/(Kinematics.PCI_x-(-Car.wb)));

end