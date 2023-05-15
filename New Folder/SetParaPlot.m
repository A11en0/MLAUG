function [ H ] = SetParaPlot(gca,gcf,H,x)
%SETPLOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% set(gca, 'XTick', x) %����X������̶����ݵ�λ��
% set(gca,'XTicklabel', {'0.01', '0.02', '0.03', '0.04', '0.05', '0.06', '0.07', '0.08'});
% set(gca, 'XTick', [0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07]); %����X������̶����ݵ�λ��
set(gca,'XTicklabel', {'0.01', '0.05', '0.1', '0.3', '0.5', '0.7', '0.9', '1.0'});

%set(get(gca,'title'),'FontSize',15,'FontName','Times New Roman');%���ñ��������С������
%set(get(gca,'XLabel'),'FontSize',20,'FontName','Times New Roman');%����X������������С������
%set(get(gca,'YLabel'),'FontSize',20,'FontName','Times New Roman');%����Y������������С������
set(gca,'FontName','Times New Roman','FontSize',10)%���������������С������
set(gcf,'position',[100,100,400,300]);
xlabel('Temperature','FontSize',10);
legend([H.h1,H.h2,H.h3],'Emotions','Scene','Yeast');
end

