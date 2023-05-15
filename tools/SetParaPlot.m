function [  ] = SetParaPlot(gca,gcf,x)
%SETPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
set(gca, 'XTick', x) %设置X坐标轴刻度数据点位置
%set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%设置标题字体大小，字型
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%设置X坐标标题字体大小，字型
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%设置Y坐标标题字体大小，字型
set(gca,'FontName','Times New Roman','FontSize',10)%设置坐标轴字体大小，字型
set(gcf,'position',[100,100,400,300]);
xlabel('log(λ3)');

end

