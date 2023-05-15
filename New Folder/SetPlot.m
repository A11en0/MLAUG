function [  ] = SetPlot(gca,gcf,H,dataname)
%SETPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
set(gca, 'XTick', [0 0.1 0.2 0.3 0.4 0.5 0.6 ]) %设置X坐标轴刻度数据点位置
set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%设置标题字体大小，字型
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%设置X坐标标题字体大小，字型
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%设置Y坐标标题字体大小，字型
set(gca,'FontName','Times New Roman','FontSize',10)%设置坐标轴字体大小，字型
set(gcf,'position',[100,100,1000,700]);
title(dataname);xlabel('MissRate');
legend([H.h1,H.h2,H.h3,H.h4,H.h5,H.h6,H.h7],'MLMF','LLSF','MLKNN','LSML','Glocal','LSFCI','CLML');
end

