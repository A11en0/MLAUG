clear;
x = [0 0.1 0.2 0.3 0.4 0.5 0.6 ];
%y = [2,3,5,6,7,8,9];
%datasets = {'enron','medical','slashdot','health','Science','education','recreation','arts','rcv1subset1_top944'};
dataname = 'rcv1subset1_top944';
Data = getData(dataname);
algNum = size(Data,1);

HL = [];RL = [];AC = [];
AP = [];Cov = [];F1 = [];
OE = [];Auc = [];
for i=1:algNum %对每一个对比算法
    Perform = Data{i};%取得实验结果
    HL = [HL;Perform(1,:)];
    AP = [AP;Perform(12,:)];
    OE = [OE;Perform(13,:)]; 
    RL = [RL;Perform(14,:)];
    Cov = [Cov;Perform(15,:)];
    Auc = [Auc;Perform(16,:)];
end    
%画图
subplot(2,3,1)%画hammingLoss
H.h1 = plot(x,HL(1,:),'-rp','LineWidth',1); hold on; %ours
H.h2 = plot(x,HL(2,:),'-gp','LineWidth',1); %LSML
H.h3 = plot(x,HL(3,:),'-bp','LineWidth',1); %
H.h4 = plot(x,HL(4,:),'-cp','LineWidth',1); %
H.h5 = plot(x,HL(5,:),'-mp','LineWidth',1); %
H.h6 = plot(x,HL(6,:),'-kp','LineWidth',1); %
H.h7 = plot(x,HL(7,:),'-yp','LineWidth',1); %
axis([0 0.6, 0.023,0.05]);
ylabel('HammingLoss');
SetPlot(gca,gcf,H,dataname);

%% 2
subplot(2,3,6)
H.h1 = plot(x,Auc(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,Auc(2,:),'-gp','LineWidth',1); hold on;
H.h3 = plot(x,Auc(3,:),'-bp','LineWidth',1); hold on;
H.h4 = plot(x,Auc(4,:),'-cp','LineWidth',1); hold on;
H.h5 = plot(x,Auc(5,:),'-mp','LineWidth',1); hold on;
H.h6 = plot(x,Auc(6,:),'-kp','LineWidth',1); hold on;
H.h7 = plot(x,Auc(7,:),'-yp','LineWidth',1); hold on;
ylabel('Auc');SetPlot(gca,gcf,H,dataname);

%% 3
subplot(2,3,2)
H.h1 = plot(x,AP(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,AP(2,:),'-gp','LineWidth',1); hold on;
H.h3 = plot(x,AP(3,:),'-bp','LineWidth',1);
H.h4 = plot(x,AP(4,:),'-cp','LineWidth',1);
H.h5 = plot(x,AP(5,:),'-mp','LineWidth',1);
H.h6 = plot(x,AP(6,:),'-kp','LineWidth',1);
H.h7 = plot(x,AP(7,:),'-yp','LineWidth',1);
ylabel('Average Precision');
SetPlot(gca,gcf,H,dataname);
%% 4
subplot(2,3,4)
H.h1 = plot(x,OE(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,OE(2,:),'-gp','LineWidth',1); hold on;
H.h3 = plot(x,OE(3,:),'-bp','LineWidth',1); hold on;
H.h4 = plot(x,OE(4,:),'-cp','LineWidth',1); hold on;
H.h5 = plot(x,OE(5,:),'-mp','LineWidth',1); hold on;
H.h6 = plot(x,OE(6,:),'-kp','LineWidth',1); hold on;
H.h7 = plot(x,OE(7,:),'-yp','LineWidth',1); hold on;
ylabel('One-Error');SetPlot(gca,gcf,H,dataname);
%% 5
subplot(2,3,3)
H.h1 = plot(x,RL(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,RL(2,:),'-gp','LineWidth',1); hold on;
H.h3 = plot(x,RL(3,:),'-bp','LineWidth',1); hold on;
H.h4 = plot(x,RL(4,:),'-cp','LineWidth',1); hold on;
H.h5 = plot(x,RL(5,:),'-mp','LineWidth',1); hold on;
H.h6 = plot(x,RL(6,:),'-kp','LineWidth',1); hold on;
H.h7 = plot(x,RL(7,:),'-yp','LineWidth',1); hold on;
ylabel('Ranking Loss');SetPlot(gca,gcf,H,dataname);
%% 6
subplot(2,3,5)
H.h1 = plot(x,Cov(1,:),'-rp','LineWidth',1); hold on;
H.h2 = plot(x,Cov(2,:),'-gp','LineWidth',1); hold on;
H.h3 = plot(x,Cov(3,:),'-bp','LineWidth',1); hold on;
H.h4 = plot(x,Cov(4,:),'-cp','LineWidth',1); hold on;
H.h5 = plot(x,Cov(5,:),'-mp','LineWidth',1); hold on;
H.h6 = plot(x,Cov(6,:),'-kp','LineWidth',1); hold on;
H.h7 = plot(x,Cov(7,:),'-yp','LineWidth',1); hold on;
ylabel('Coverage');SetPlot(gca,gcf,H,dataname);




