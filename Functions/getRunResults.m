function [run] = getRunResults(path)
run.convergeFile = importConvergencefile(char(path),47,inf);
run.MaxTimestep = max(run.convergeFile.timeStep);
run.liftCoefficient = getAverage(run.convergeFile.liftCoefficient,100);
run.dragCoefficient = getAverage(run.convergeFile.dragCoefficient,100);
run.residuals = run.convergeFile.overallResidualFlow;
run.totalCPUTime = str2num(char(run.convergeFile.CPUTime(end)));
run.CPUTime = run.totalCPUTime/run.MaxTimestep;
run.finalResidual = str2num(char(run.convergeFile.overallResidualFlow(end)));
%run.convergeFile = NaN;
end