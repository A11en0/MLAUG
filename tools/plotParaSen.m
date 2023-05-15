path = '.\paraSen\enron\';
ParaName = 'lambda3.xls';
path = [path,ParaName];
data = xlsread(path);
data = data(12:15,:);
x = [-8 -6 -4 -2 0 2 4 6];
%% plot
subplot(2,2,1)
H = plot(x,data(1,:),'-rp','LineWidth',1);
axis([-8 6, 0.5,0.75]); ylabel('AveragePrecision'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,x)
%% 2
subplot(2,2,2)
plot(x,data(2,:),'-rp','LineWidth',1);
axis([-8 6,  0.1,0.5]);ylabel('OneError'); % lamda1:0.54,0.59  2:0.56,0.58   3:0.52,0.60  4:0.52,0.68
SetParaPlot(gca,gcf,x)
%% 3
subplot(2,2,3)
plot(x,data(3,:),'-rp','LineWidth',1);
axis([-8 6,  0.05, 0.15]);ylabel('RankingLoss');% lamda1:0.09,0.12  2:0.11,0.116  3:0.05,0.25  4:0.07,0.18
SetParaPlot(gca,gcf,x)
%% 4
subplot(2,2,4)
plot(x,data(4,:),'-rp','LineWidth',1);
axis([-8 6, 0.2,0.3]);ylabel('Coverage');% lamda1:0.142,0.152  2:0.148,0.152  3:0.08,0.28  4:0.12£¬0.20
SetParaPlot(gca,gcf,x)