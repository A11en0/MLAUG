% path = 'C:\Users\wsco19\Desktop\Codes\junlong\PanSen\scene\';
% ParaName = 'lambda5.xls';
% path = [path,ParaName];
path = 'statstic.csv';
data = xlsread(path);
data = data(1:4,:);
x = [-2 0 2 4 6];
%% plot
subplot(2,2,1)
H = plot(x,data(1,:),'-rp','LineWidth',1);
axis([-2 6, 0.15 0.25]); ylabel('AveragePrecision'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,x)
%% 2
subplot(2,2,2)
plot(x,data(2,:),'-rp','LineWidth',1);
axis([-2 6, 0 1]);ylabel('OneError'); % lamda1:0.54,0.59  2:0.56,0.58   3:0.52,0.60  4:0.52,0.68
SetParaPlot(gca,gcf,x)
%% 3
subplot(2,2,3)
plot(x,data(3,:),'-rp','LineWidth',1);
axis([-2 6, 0 1]);ylabel('RankingLoss');% lamda1:0.09,0.12  2:0.11,0.116  3:0.05,0.25  4:0.07,0.18
SetParaPlot(gca,gcf,x)
%% 4
subplot(2,2,4)
plot(x,data(4,:),'-rp','LineWidth',1);
axis([-2 6, 0 1]);ylabel('Coverage');% lamda1:0.142,0.152  2:0.148,0.152  3:0.08,0.28  4:0.12£¬0.20
SetParaPlot(gca,gcf,x)