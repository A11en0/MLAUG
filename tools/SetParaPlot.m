function [  ] = SetParaPlot(gca,gcf,x)
%SETPLOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
set(gca, 'XTick', x) %����X������̶����ݵ�λ��
%set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%���ñ��������С������
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%����X������������С������
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%����Y������������С������
set(gca,'FontName','Times New Roman','FontSize',10)%���������������С������
set(gcf,'position',[100,100,400,300]);
xlabel('log(��3)');

end

