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

Result.timesArray = dateStart+seconds(Results.Times);


%% Get Airspeed
prompt = {"Enter the airspeed (in m/s) " + file};
dlgtitle = 'Airspeed';
definput = {'10'};
dims = [1 100];
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
Result.velocity = str2double(cell2mat(answer));

%% Calculate Advance Ratio

%% Get Airspeed
prompt = {"Enter the Diameter (in inches) " + file};
dlgtitle = 'Diameter';
definput = {'21'};
dims = [1 100];
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
Result.Diameter = str2double(cell2mat(answer))*0.0254;


Result.AdvanceRatio = Result.velocity./Results.MotorOpticalSpeedRPM./Result.Diameter;



f = figure(5);
%f.Position = [10 50 1920 1080];
plot(Result.AdvanceRatio,Results.ThrustN);
hold on

ylabel('Thrust [N]')
yyaxis right

plot(Result.AdvanceRatio,Results.TorqueNm);

ylabel('Torque [Nm]')
xlabel('Advance Ratio')
legend('Thrust' ,'Torque')

yyaxis left
legend('Location','southeast')
grid on

legend('Location','southeast')



linkdata on
saveas(gcf,savepath +'MotorResults.jpg');




