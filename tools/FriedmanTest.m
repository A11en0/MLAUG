clear;
%load Data
data = getDataByMet(15,4);%16代表
% s= reshape(X,6,11);
% s = s';
% disp(s);
labels={'MLMF','LLSF','MLKNN','LSML','Glocal','LSFCI','CLML'};%方法的标签
 
alpha=0.05; %显著性水平0.1,0.05或0.01

%Nemenyi test  data':n*k, n:数据集个数，k:算法个数
[cd,X] = criticaldifference(data',labels,alpha);
disp(X);

%Friedman test
K = 7;
N = 9;
F = calF_f(K,N,X);
disp(F);
