clear;
%load Data
data = getDataByMet(15,4);%16����
% s= reshape(X,6,11);
% s = s';
% disp(s);
labels={'MLMF','LLSF','MLKNN','LSML','Glocal','LSFCI','CLML'};%�����ı�ǩ
 
alpha=0.05; %������ˮƽ0.1,0.05��0.01

%Nemenyi test  data':n*k, n:���ݼ�������k:�㷨����
[cd,X] = criticaldifference(data',labels,alpha);
disp(X);

%Friedman test
K = 7;
N = 9;
F = calF_f(K,N,X);
disp(F);
