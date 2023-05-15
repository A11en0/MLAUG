function [ H ] = SetParaPlot(gca,gcf,H,x)
%SETPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
% set(gca, 'XTick', x) %设置X坐标轴刻度数据点位置
% set(gca,'XTicklabel', {'0.01', '0.02', '0.03', '0.04', '0.05', '0.06', '0.07', '0.08'});
% set(gca, 'XTick', [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07]); %设置X坐标轴刻度数据点位置
set(gca,'XTicklabel', {'0.01', '0.05', '0.1', '0.3', '0.5', '0.7', '0.9', '1.0'});

%set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%设置标题字体大小，字型
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%设置X坐标标题字体大小，字型
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%设置Y坐标标题字体大小，字型
set(gca,'FontName','Times New Roman','FontSize',10)%设置坐标轴字体大小，字型
set(gcf,'position',[100,100,400,300]);
xlabel('Temperature','FontSize',10);
legend([H.h1,H.h2,H.h3],'Emotions','Scene','Yeast');
end

