function [output] = GetAverage(Results,t0,t1, velocity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

output.ThrustN = mean(Results(Results.Times<t1&Results.Times>t0,:).ThrustN);
output.ESCs = mean(Results(Results.Times<t1&Results.Times>t0,:).ESCs);
output.TorqueNm = mean(Results(Results.Times<t1&Results.Times>t0,:).TorqueNm);
output.VoltageV = mean(Results(Results.Times<t1&Results.Times>t0,:).VoltageV);
output.CurrentA = mean(Results(Results.Times<t1&Results.Times>t0,:).CurrentA);
output.MotorOpticalSpeedRPM = mean(Results(Results.Times<t1&Results.Times>t0,:).MotorOpticalSpeedRPM);
output.ElectricalPowerW = mean(Results(Results.Times<t1&Results.Times>t0,:).ElectricalPowerW);
output.MechanicalPowerW = mean(Results(Results.Times<t1&Results.Times>t0,:).MechanicalPowerW);
output.MotorEfficiency = mean(Results(Results.Times<t1&Results.Times>t0,:).MotorEfficiency);
output.PropellerMechEfficiencyNW = mean(Results(Results.Times<t1&Results.Times>t0,:).PropellerMechEfficiencyNW);
output.OverallEfficiencyNW = mean(Results(Results.Times<t1&Results.Times>t0,:).OverallEfficiencyNW);
output.N76TempC = mean(Results(Results.Times<t1&Results.Times>t0,:).N76TempC);
output.ThrustN = mean(Results(Results.Times<t1&Results.Times>t0,:).ThrustN);
output.PropellerEfficiency = mean(Results(Results.Times<t1&Results.Times>t0,:).ThrustN./Results(Results.Times<t1&Results.Times>t0,:).MechanicalPowerW.*velocity);

end

