function [  ] = SetPlot(gca,gcf,H,dataname)
%SETPLOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
set(gca, 'XTick', [0 0.1 0.2 0.3 0.4 0.5 0.6 ]) %����X������̶����ݵ�λ��
set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%���ñ��������С������
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%����X������������С������
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%����Y������������С������
set(gca,'FontName','Times New Roman','FontSize',10)%���������������С������
set(gcf,'position',[100,100,1000,700]);
title(dataname);xlabel('MissRate');
legend([H.h1,H.h2,H.h3,H.h4,H.h5,H.h6,H.h7],'MLMF','LLSF','MLKNN','LSML','Glocal','LSFCI','CLML');
end

