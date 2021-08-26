%% Initialisation

close all

%% Load Files
% LoadRefCase
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_280_ConstVel_2021-06-16_171414\Result_ConstVel_2021-06-16_171414.mat')
Result_Ref = Result;

% Load 50W
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_281_ConstVel_2021-06-16_171836\Result_ConstVel_2021-06-16_171836.mat')
Result_50 = Result;

% Load 80W 
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_279_ConstVel_2021-06-16_171040\Result_ConstVel_2021-06-16_171040.mat')
Result_80 = Result;

%Load 110W
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_278_ConstVel_2021-06-16_170733\Result_ConstVel_2021-06-16_170733.mat')
Result_110 = Result;


% LoadRefCase5ms
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_276_ConstVel_2021-06-16_165530\Result_ConstVel_2021-06-16_165530.mat')
Result_Ref5ms = Result;

% Load 50W
load('C:\Users\nicol\WebstormProjects\RCBenchmark\CSV Files\IPS -5\Run_277_ConstVel_2021-06-16_170430\Result_ConstVel_2021-06-16_170430.mat')
Result_55 = Result;


f = figure(1);

plot(Result_Ref.Results.Times-2,movmean(Result_Ref.Results.Efficiency,101));
hold on
plot(Result_50.Results.Times,movmean(Result_50.Results.Efficiency,101));
plot(Result_80.Results.Times,movmean(Result_80.Results.Efficiency+0.02,101));
plot(Result_110.Results.Times,movmean(Result_110.Results.Efficiency+0.04,101));
ylabel('Efficiency [-]')
ylim([ 0.4 0.7]);
xlim([ -2 60]);
xlabel('Time [s]')
grid on
legend('O W' ,'50 W', '80 W','110 W')
legend('Location','northeast')

f = figure(2);

plot(Result_Ref.Results.Times-2,movmean(Result_Ref.Results.Efficiency,101));
hold on
%plot(Result_50.Results.Times,movmean(Result_50.Results.Efficiency,101));
%plot(Result_80.Results.Times,movmean(Result_80.Results.Efficiency+0.02,101));
plot(Result_110.Results.Times,movmean(Result_110.Results.Efficiency+0.04,101));
ylabel('Efficiency [-]')
ylim([ 0.4 0.7]);
xlim([ -2 60]);
xlabel('Time [s]')
grid on
legend('No IPS' ,'Active IPS')
legend('Location','northeast')


f = figure(3);

plot(Result_Ref5ms.Results.Times+1,movmean(Result_Ref5ms.Results.Efficiency,201));
hold on
plot(Result_55.Results.Times,movmean(Result_55.Results.Efficiency,201));
ylabel('Efficiency [-]')
ylim([ 0.2 0.6]);
xlim([ -2 60]);
xlabel('Time [s]')
grid on
legend('O W' ,'55 W')
legend('Location','northeast')



f = figure(4);

plot(Result_Ref5ms.Results.Times+1,movmean(Result_Ref5ms.Results.ThrustN,201));
hold on
plot(Result_55.Results.Times,movmean(Result_55.Results.ThrustN,201));
ylabel('Thrust [N]')
%ylim([ 0.2 0.6]);
xlim([ -2 60]);
xlabel('Time [s]')
grid on
legend('O W' ,'55 W')
legend('Location','northeast')

f = figure(5);

plot(Result_Ref5ms.Results.Times+1,movmean(-Result_Ref5ms.Results.TorqueNm,201));
hold on
plot(Result_55.Results.Times,movmean(-Result_55.Results.TorqueNm,201));
ylabel('Torque [Nm]')
%ylim([ 0.2 0.6]);
xlim([ -2 60]);
xlabel('Time [s]')
grid on
legend('O W' ,'55 W')
legend('Location','northeast')