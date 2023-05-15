% path = 'C:\Users\wsco19\Desktop\Codes\junlong\PanSen\scene\';
% ParaName = 'lambda5.xls';
% path = [path,ParaName];
% data = xlsread(path);
% data = data(1:4,:);
clear;
paraName = 'temperature';   % temperature
Data = getDataForPara(paraName);  % 按照数据集取得，每个cell是一个数据集

dataNum = size(Data,1);
HL = [];RL = [];AC = [];
AP = [];Cov = [];F1 = [];
OE = [];MicroF1 = [];
for i=1:dataNum %对每一个数据集
    Perform = Data{i};%取得实验结果
    HL = [HL;Perform(1,:)];
    AP = [AP;Perform(2,:)];
    OE = [OE;Perform(3,:)]; 
    RL = [RL;Perform(4,:)];
    Cov = [Cov;Perform(5,:)];
    MicroF1 = [MicroF1;Perform(7,:)];
end

x = [0.01, 0.05, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0];
% plot Hamming
subplot(2,2,1)
H.h1 = plot(x,HL(1,:),'-rp','LineWidth',1); hold on;  % 第一个数据集
H.h2 = plot(x,HL(2,:),'-bp','LineWidth',1);
H.h3 = plot(x,HL(3,:),'-gp','LineWidth',1);
ylabel('Hamming'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,H,x);
% 2
subplot(2,2,2)
H.h1 = plot(x,AP(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,AP(2,:),'-bp','LineWidth',1);
H.h3 = plot(x,AP(3,:),'-gp','LineWidth',1);
ylabel('Average Precision'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,H,x);
% 3
subplot(2,2,3)
H.h1 = plot(x,OE(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,OE(2,:),'-bp','LineWidth',1);
H.h3 = plot(x,OE(3,:),'-gp','LineWidth',1);
ylabel('One Error'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,H,x);
% 4
subplot(2,2,4)
H.h1 = plot(x,RL(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,RL(2,:),'-bp','LineWidth',1);
H.h3 = plot(x,RL(3,:),'-gp','LineWidth',1);
ylabel('Ranking Loss'); % lamda1:0.53,0.58  2:0.54,0.56  3:0.4,0.6 4:0.4,0.6
SetParaPlot(gca,gcf,H,x);
set(gcf,'defaultfigurecolor','w');
% set(gcf,'Position', [0, 0, 1000, 600]);
export_fig 'paraName' -pdf -r300;