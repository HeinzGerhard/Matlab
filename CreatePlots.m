%% Automaticaly get Polar from Files

% Get Data from Fensap

clc
clear
close all

path = "C:\Users\nicolacm\OneDrive - NTNU\Simulations\Downloads";
[file,path] = uigetfile(path+'/*',...
                        'Select an Results File');
i = 1;
%Polar = table
%% Loop over Runs

foldername = strcat(path);
mkdir (path + "\PostPro\Plots");


% get results from converg file
result = getRunResults(strcat(foldername,file));
Result(i).cl = result.liftCoefficient;
Result(i).cd = result.dragCoefficient ;
Result(i).residuals = str2num(char(result.residuals)) ;
Result(i).timeSteps = result.MaxTimestep ;
Result(i).CPUTime = result.CPUTime;
Result(i).totalCPUTime = result.totalCPUTime ;
Result(i).finalResidual = result.finalResidual ;


%% Sort and convert Polar
%[~, order] = sort([Result(:).alpha],'ascend');
%PolarSorted = Result;
%PolarTable = struct2table(PolarSorted);

%% Plot Figures
figure(1)
ax1 = subplot(2,2,1);
hold on
yyaxis left
set(gca, 'YScale', 'log')
plot(Result(i).residuals);
ylabel('Overall Residual')
xlabel('Iterations')

ax2 = subplot(2,2,2);

hold on
set(gca, 'YScale', 'log')
plot(str2num(char(result.convergeFile.overallResidualFlow)),'-k');
plot(str2num(char(result.convergeFile.navierStokesResidual)),'-r');
plot(result.convergeFile.energyResidual,'-g');
plot(result.convergeFile.SpalartAllamrasResidual,'-b');
plot(result.convergeFile.kayResidual,'k--');
plot(result.convergeFile.epsilonOmegaResidual,'r--');
plot(result.convergeFile.intermittencyResidual,'g--');
legend('overall','Navier Stokes', 'Energy', 'Spalart Allamras', 'kay','intermittency')
ylabel('Residuals')
xlabel('Iterations')

ax3 = subplot(2,2,3);

hold on
yyaxis left
plot(result.convergeFile.dragCoefficient);
ylabel('Drag')
yyaxis right
plot(result.convergeFile.liftCoefficient);
ylabel('Lift')
legend('Drag','Lift')
xlabel('Iterations')

ax4 = subplot(2,2,4);
txt = ['Average height: ' num2str(2) ' units'];
%text(4,0.5,txt)
plot(str2num(char(result.convergeFile.CPUTime)));
ylabel('Total CPU Time')
xlabel('Iterations')
linkaxes([ax1,ax2, ax3],'x');

x0=10;
y0=10;
width=1920;
height=1080;
set(gcf,'position',[x0,y0,width,height])

saveas(gcf,path + "\PostPro\Plots\" +'Results.png');



figure(2)
hold on
yyaxis left
set(gca, 'YScale', 'log')
plot(Result(i).residuals);
ylabel('Overall Residual')
xlabel('Iterations')

set(gcf,'position',[x0,y0,width,height])
saveas(gcf,path + "\PostPro\Plots\" +'Residual1.png');
close 2

figure(2)
hold on
set(gca, 'YScale', 'log')
plot(str2num(char(result.convergeFile.overallResidualFlow)),'-k');
plot(str2num(char(result.convergeFile.navierStokesResidual)),'-r');
plot(result.convergeFile.energyResidual,'-g');
plot(result.convergeFile.SpalartAllamrasResidual,'-b');
plot(result.convergeFile.kayResidual,'k--');
plot(result.convergeFile.epsilonOmegaResidual,'r--');
plot(result.convergeFile.intermittencyResidual,'g--');
legend('overall','Navier Stokes', 'Energy', 'Spalart Allamras', 'kay','intermittency')
ylabel('Residuals')
xlabel('Iterations')
set(gcf,'position',[x0,y0,width,height])
saveas(gcf,path + "\PostPro\Plots\" +'Residual2.png');
close 2


figure(2)
hold on
yyaxis left
plot(result.convergeFile.dragCoefficient);
ylabel('Drag')
yyaxis right
plot(result.convergeFile.liftCoefficient);
ylabel('Lift')
legend('Drag','Lift')
xlabel('Iterations')
set(gcf,'position',[x0,y0,width,height])
saveas(gcf,path + "\PostPro\Plots\" +'LiftDrag.png');
close 2

%% Export Table

disp(strcat('Export Tables to:', path));

save(strcat(path , '\PostPro\Plots\Polar.mat'), 'Result');

%% Export Exel

Excel = [result.liftCoefficient, result.dragCoefficient, result.finalResidual, result.totalCPUTime, result.MaxTimestep];

fid=fopen(strcat(path , '\PostPro\Plots\Excel.csv'),'w');
for k=1:length(Excel)
    fprintf(fid, Excel(k)+",");
end
%close file indentifier
fclose(fid);

Excel