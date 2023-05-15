clear;
%load Data
% data = getDataByMet(15,4);%16代表
% s= reshape(X,6,11);
% s = s';
% disp(s);
labels={'MLKNN','LLSF','Glocal','LSML','CLML','Ours'};%方法的标签
 

data = [
0.197	0.018	0.038	0.005 0.06	0.022
0.191	0.018	0.042	0.003 0.055	0.017
0.207	0.019	0.038	0.002	0.055	0.017
0.248	0.022	0.046	0.002	0.056	0.021
0.205	0.026	0.038	0.002 0.07	0.026
0.2	0.018	0.038	0.030 0.054	0.02
0.19	0.017	0.036	0.002	0.054	0.017
];

alpha=0.05; %显著性水平0.1,0.05或0.01

%Nemenyi test  data:n*k, n:数据集个数，k:算法个数
[cd,X] = criticaldifference(data,labels,alpha);
disp(X);

%Friedman test
K = 6;
N = 7;
F = calF_f(K,N,X);
disp(F);
