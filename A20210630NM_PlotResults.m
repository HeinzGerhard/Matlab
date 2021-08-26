close all
clear
clc
% myDir = uigetdir
% myFiles = dir(fullfile(myDir,'*.csv'));
% for k = 1:length(myFiles)
%     close all
%   file = myFiles(k).name;
%   path = myFiles(k).folder;
%% Initilisation

avergeTime = 1;
averageTimeClean = 5;
% 
%% Import ResultsFile
path = "";
try, load('lastpath.mat'), catch ME, ME.stack, end
if path == 0
    path = "";
end
filename = "";
[file,path] = uigetfile(append(path,'/*.csv'),...
                        'Select an Results File');
                save('lastpath.mat', 'path')
save('lastpath.mat', 'path');
%Results = importResultsFile(path + "\" + file);
Results = importResultsFile(path +"" + file);

%% Get RunNumber
prompt = {"Enter the Run Number " + file};
dlgtitle = 'RunNumber';
definput = {'1'};
dims = [1 1000];
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
run = cell2mat(answer);

mkdir (path + "Run_" +  run + "_" + strrep(file,".csv",''));

%% Get Time and Date from filename
split = strsplit(file,"_");
TimeString = split(3);
DateString = split(2);
hour = str2double(extractBetween(TimeString,1,2));
minute = str2double(extractBetween(TimeString,3,4));
second = str2double(extractBetween(TimeString,5,6));
split = strsplit(cell2mat(DateString),"-");
year = str2double(split(1));
month = str2double(split(2));
day = str2double(split(3));
dateStart = datetime(year,month,day,hour,minute,second);
savepath = path + "Run_" +  run + "_" + strrep(file,".csv",'') + "\";

timesArray = dateStart+seconds(Results.Times);


%% Get Airspeed
prompt = {"Enter the airspeed (in m/s) " + file};
dlgtitle = 'Airspeed';
definput = {'10'};
dims = [1 100];
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
velocity = str2double(cell2mat(answer));

f = figure(9);

plot(Results.Times,Results.ThrustN);
hold on
plot(Results.Times,-10*Results.TorqueNm);
ylabel('Thrust [N], Torque [1/10 N]')
yyaxis right

plot(Results.Times,Results.ThrustN./Results.MechanicalPowerW.*str2double(cell2mat(answer)));

ylim([ 0 1]);
ylabel('Efficiancy [-]')
xlabel('Time')
legend('Thrust' ,'Torque', 'Efficiancy')

yyaxis left
legend('Location','southeast')


%% Get Values

prompt = 'Time of Icing start (s)';
dlgtitle = 'Icing Time';
definput = {'30'};
dims = [0 1000];
%opts.Interpreter = 'tex';
t0 = str2double(cell2mat(inputdlg(prompt)));
%t0 = 0;
Results.Times = Results.Times - t0;

%% Get Values

prompt = 'Temperature';
dlgtitle = 'file';
definput = {'0'};
dims = [-50 0];
%opts.Interpreter = 'tex';
MeanData.Setup.T = str2double(cell2mat(inputdlg(prompt)));
prompt = 'Propeller';
dlgtitle = 'file';
definput = {'0'};
dims = [-50 2];
%opts.Interpreter = 'tex';
MeanData.Setup.Prop = str2double(cell2mat(inputdlg(prompt)));
prompt = 'Error';
dlgtitle = 'file';
definput = {'0'};
dims = [-50 10];
%opts.Interpreter = 'tex';
MeanData.Setup.Err = str2double(cell2mat(inputdlg(prompt)));
MeanData.Setup.velocity = velocity;

%% Testbench Figure
f = figure(1);

ax1 = subplot(2,2,1);

f.Position = [570 500 1920 1080];
plot(Results.Times,Results.ElectricalPowerW);
hold on
plot(Results.Times,Results.MechanicalPowerW);
ylabel('Power')

linkdata on

yyaxis right

plot(Results.Times,Results.MotorOpticalSpeedRPM, '-k');
plot(Results.Times,Results.TargetRPM, '--k');

ylabel('RPM')
xlabel('Time')
legend('Electrical', 'Mechanical' ,'RPM', 'Target')

linkdata on
yyaxis left
legend('Location','southeast')
grid on

ax2 = subplot(2,2,2);

plot(Results.Times,Results.VoltageV);
hold on
plot(Results.Times,Results.CurrentA);
ylabel('Voltage/Current')
yyaxis right

plot(Results.Times,Results.Mark, '-k');

ylabel('Mark')
xlabel('Time')
legend('Voltage', 'Current' ,'Mark')

yyaxis left
legend('Location','southeast')
grid on

ax3 = subplot(2,2,3);

plot(Results.Times,Results.MotorEfficiency);
hold on
ylabel('Efficiency [%]')

axis([0 inf 50 100]);

yyaxis right

plot(Results.Times,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Eff' ,'RPM')

yyaxis left

legend('Location','southeast')
grid on
ax4 = subplot(2,2,4);
plot(Results.Times,Results.N76TempC);
hold on
ylabel('Temp [C]')
yyaxis right

plot(Results.Times,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Temperature' ,'RPM')

yyaxis left

legend('Location','southeast')
grid on

linkaxes([ax1,ax2, ax3, ax4],'x');

linkdata on
saveas(gcf,savepath +'Testbench.jpg');

% %% Controller Figure
f = figure(2);
f.Position = [0 0 1920 1080];
ax1 = subplot(2,2,1);
yyaxis right
%plot(Results.Times,Results.Change);
hold on
%plot(Results.Times,Results.TargetRPM-Results.ThrustN);
plot(Results.Times,Results.P./Results.kp);
ylabel('RPM')
%ylim([-100 100])

yyaxis left


plot(Results.Times,Results.P);
plot(Results.Times,Results.I);
plot(Results.Times,Results.D);
ylabel('PID [PWM]')

legend('P', 'I', 'D','Change','Error','Dif' );
legend('Location','southeast')
grid on


ax2 = subplot(2,2,2);

yyaxis left
plot(Results.Times,Results.kp);
hold on
plot(Results.Times,Results.ki);
plot(Results.Times,Results.kd);
ylabel('RPM')

yyaxis right


plot(Results.Times,Results.P);
plot(Results.Times,Results.I);
plot(Results.Times,Results.D);
ylabel('PID [PWM]')

legend('kP', 'kI', 'kD','P', 'I', 'D' );
legend('Location','southeast')
grid on

ax3 = subplot(2,2,3);
plot(Results.Times,Results.ESCs);
hold on
ylabel('ESC')
ylim([1000 2000])

legend('Location','southeast')
legend('RPM')
grid on

ax4 = subplot(2,2,4);

plot(Results.Times,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('RPM')

legend('Location','southeast')
grid on

linkaxes([ax1,ax2, ax3, ax4],'x');

linkdata on
saveas(gcf,savepath +'Controller.jpg');

%% Results Figure

f = figure(3);
f.Position = [10 50 1920 1080];
ax1 = subplot(2,2,1);
plot(Results.Times,Results.ThrustN);
hold on
ylabel('Thrust [N]')
yyaxis right

plot(Results.Times,-Results.TorqueNm);

ylabel('Torque [Nm]')
xlabel('Time')
legend('Thrust' ,'Torque')

yyaxis left
legend('Location','southeast')
grid on

ax2 = subplot(2,2,2);
plot(Results.Times,-Results.ThrustN./Results.TorqueNm);
ylim([0 30])
hold on
ylabel('Thrust/Torque [N/Nm]')
yyaxis right

plot(Results.Times,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Thrust/Torque' ,'RPM')
grid on

yyaxis left
legend('Location','east')
grid on

ax3 = subplot(2,2,3);

plot(Results.Times,Results.ElectricalPowerW);
hold on
plot(Results.Times,Results.MechanicalPowerW);
plot(Results.Times,Results.ThrustN.*str2double(cell2mat(answer(1))));
%plot(Results.Times,Results.ThrustN.*17);
ylabel('Power')
%yyaxis right

%plot(Results.Times,Results.MotorOpticalSpeedRPM, '-k');
%plot(Results.Times,Results.TargetRPM, '--k');

%ylabel('RPM')
xlabel('Time')
legend('Electrical', 'Mechanical', 'Propeller' )
grid on

yyaxis left
legend('Location','southeast')
ax4 = subplot(2,2,4);
plot(Results.Times,Results.ThrustN./Results.MechanicalPowerW.*str2double(cell2mat(answer)));
ylim([0 1])
hold on
ylabel('Eff [-]')
axis([0 inf 0 1]);
yyaxis right

plot(Results.Times,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Eff' ,'RPM')

yyaxis left
legend('Location','east')
grid on
linkaxes([ax1,ax2, ax3, ax4],'x');
linkdata on
saveas(gcf,savepath +'Results.jpg');
% 
% %% Results figure Time based
f = figure(4);
f.Position = [10 50 1920 1080];
ax1 = subplot(2,2,1);
plot(timesArray,Results.ThrustN);
hold on
ylabel('Thrust [N]')
yyaxis right

plot(timesArray,-Results.TorqueNm);

ylabel('Torque [Nm]')
xlabel('Time')
legend('Thrust' ,'Torque')

yyaxis left
legend('Location','southeast')
grid on
ax2 = subplot(2,2,2);
plot(timesArray,-Results.ThrustN./Results.TorqueNm);
ylim([0 30])
hold on
ylabel('Thrust/Torque [N/Nm]')
yyaxis right

plot(timesArray,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Thrust/Torque' ,'RPM')

yyaxis left
legend('Location','east')
grid on
ax3 = subplot(2,2,3);

plot(timesArray,Results.ElectricalPowerW);
hold on
plot(timesArray,Results.MechanicalPowerW);
plot(timesArray,Results.ThrustN.*str2double(cell2mat(answer(1))));
%plot(Results.Times,Results.ThrustN.*17);
ylabel('Power')
%yyaxis right

%plot(Results.Times,Results.MotorOpticalSpeedRPM, '-k');
%plot(Results.Times,Results.TargetRPM, '--k');

%ylabel('RPM')
xlabel('Time')
legend('Electrical', 'Mechanical', 'Propeller' )

yyaxis left
legend('Location','southeast')
grid on
ax4 = subplot(2,2,4);
plot(timesArray,Results.ThrustN./Results.MechanicalPowerW.*str2double(cell2mat(answer)));
ylim([0 1])
hold on
ylabel('Eff [-]')
ylim([ 0 1]);
yyaxis right

plot(timesArray,Results.MotorOpticalSpeedRPM);

ylabel('RPM')
xlabel('Time')
legend('Eff' ,'RPM')

yyaxis left
legend('Location','northeast')
grid on
linkaxes([ax1,ax2, ax3, ax4],'x');
linkdata on
saveas(gcf,savepath +'TimeResults.jpg');




%% Matrix for Shedding detection
maxt = max(Results.Times);
steps = round(maxt--5);
T = zeros(steps,1);
for t = 1:steps
    H(t,1) = mean(Results(Results.Times<0+t&Results.Times>0-1+t,:).PropellerMechEfficiencyNW);
    
end

i = 1;
lastfound = 0;
sT = double.empty;
for t = 1:steps-2
    if t>lastfound+4
        if (H(t+2)>H(t)*1.051)
            sT(i) = t+1;
            i = i+1;
            lastfound = t;
        end
    end
end


figure(5)
plot(Results.Times,Results.ThrustN./Results.MechanicalPowerW.*str2double(cell2mat(answer)));
ylim([0 1])
hold on
ylabel('Eff [-]')
ylim([ 0 1]);
yyaxis right
ylim([ 0 1]);
for t = sT
    plot([t,t],[0,1],'-r','LineWidth',2);
end

plot([0,0],[0,1],'-g','LineWidth',2);
ylabel('Shedding')
xlabel('Time')
legend('Eff')

yyaxis left
legend('Location','northeast')
saveas(gcf,savepath +'Shedding.jpg');

% prompt = 'First Ice Shedding (s)';
% dlgtitle = 'Shedding';
% definput = t1;
% dims = [1 1000];
% 
% 
% t1 = str2double(cell2mat(inputdlg(prompt,dlgtitle,dims,definput)));
% 
% 
% 
% prompt = 'Second Ice Shedding (s)';
% definput = t2;
% 
% %opts.Interpreter = 'tex';
% %answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
% 
% 
% 
% t2 = str2double(cell2mat(inputdlg(prompt,dlgtitle,dims,definput)));
% prompt = 'Third Ice Shedding (s)';
% definput = t3;
% 
% t3 = str2double(cell2mat(inputdlg(prompt,dlgtitle,dims,definput)));
% prompt = 'Fourth Ice Shedding (s)';
% definput = t4;
% 
% t4 = str2double(cell2mat(inputdlg(prompt,dlgtitle,dims,definput)));
%Results.Times = categorical(Results.Times);

%% TimeSpecific 
MeanData.CleanData=GetAverage(Results,t0-averageTimeClean,t0, velocity);
MeanData.Data010=GetAverage(Results,t0+9.5,t0+10.5, velocity);
MeanData.Data020=GetAverage(Results,t0+19.5,t0+20.5, velocity);
MeanData.Data030=GetAverage(Results,t0+29.5,t0+30.5, velocity);
MeanData.Data060=GetAverage(Results,t0+59.5,t0+60.5, velocity);
MeanData.Data090=GetAverage(Results,t0+89.5,t0+90.5, velocity);
MeanData.Data120=GetAverage(Results,t0+119.5,t0+120.5, velocity);
MeanData.Data180=GetAverage(Results,t0+179.5,t0+180.5, velocity);
MeanData.Data240=GetAverage(Results,t0+239.5,t0+240.5, velocity);
MeanData.Data300=GetAverage(Results,t0+299.5,t0+300.5, velocity);
MeanData.Data360=GetAverage(Results,t0+359.5,t0+360.5, velocity);

%% Shedding

index = 0;
for (i =sT)
    MeanData.Shedding.("Shedding"+index).Pre = GetAverage(Results,i-2+t0,i-1+t0, velocity);
    MeanData.Shedding.("Shedding"+index).Post = GetAverage(Results,i+1+t0,i+2+t0, velocity);
    index = index+1;
end

MeanData.velocity = str2double(cell2mat(answer));
save(savepath +'MeanData_'+strrep(file,".csv",'')+'.mat','MeanData');

%% Calculate Derived Data

Result.A010 = MeanData.Data010.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A020 = MeanData.Data020.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A030 = MeanData.Data030.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A060 = MeanData.Data060.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A090 = MeanData.Data090.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A120 = MeanData.Data120.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A180 = MeanData.Data180.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A240 = MeanData.Data240.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A300 = MeanData.Data300.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
Result.A360 = MeanData.Data360.PropellerEfficiency/MeanData.CleanData.PropellerEfficiency;
index = 0;
for (i =sT)
    Result.Shedding.("Shedding"+index).Strength = MeanData.Shedding.("Shedding"+index).Post.PropellerEfficiency/MeanData.Shedding.("Shedding"+index).Pre.PropellerEfficiency;
    Result.Shedding.("Shedding"+index).T = i;
    index = index+1;
end


save(savepath +'Result_'+strrep(file,".csv",'')+'.mat','Result');
Excel = [day+"."+month+"."+year,hour+":"+minute+":"+second,file,MeanData.Setup.T,MeanData.Setup.Prop, velocity,MeanData.CleanData.MotorOpticalSpeedRPM, MeanData.CleanData.PropellerEfficiency,Result.A010, Result.A020,Result.A030,Result.A060,Result.A090,Result.A120,Result.A180,Result.A240,Result.A300,Result.A360, MeanData.CleanData.ThrustN,MeanData.Data010.ThrustN,MeanData.Data020.ThrustN,MeanData.Data030.ThrustN,MeanData.Data060.ThrustN,MeanData.Data090.ThrustN,MeanData.Data120.ThrustN,MeanData.Data180.ThrustN,MeanData.Data240.ThrustN,MeanData.Data300.ThrustN,MeanData.Data360.ThrustN, MeanData.CleanData.TorqueNm,MeanData.Data010.TorqueNm,MeanData.Data020.TorqueNm,MeanData.Data030.TorqueNm,MeanData.Data060.TorqueNm,MeanData.Data090.TorqueNm,MeanData.Data120.TorqueNm,MeanData.Data180.TorqueNm,MeanData.Data240.TorqueNm,MeanData.Data300.TorqueNm,MeanData.Data360.TorqueNm ];

index = 0;
for (i =sT)
    s = size(Excel);
    length = s(2);
    Excel(length+1) = Result.Shedding.("Shedding"+index).T;
    Excel(length+2) = Result.Shedding.("Shedding"+index).Strength;
    index = index+1;
end

Excel
close all
