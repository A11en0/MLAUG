MetricName = 'hammingLoss';
datasets = {'genbase','medical','enron','Science','education','recreation','arts','rcv1subset1_top944','rcv1subset2_top944'};
algorithms = {'MLMF2\','LLSF\','MLKNN\','LSML-MF\','Glocal-MF\'};
MissRate = 3;
Result = zeros(5,9);
for i=1:size(algorithms,2)
    path = ['C:\Users\HeLu\Desktop\',algorithms{i}];
    for j=1:size(datasets,2)
        filename = [datasets{j},'.xls'];
        path2 = [path,filename];
        dataMatrix = xlsread(path2);
        Result(i,j) = dataMatrix(1,3);%dataMetrix(i,j) i代表metricname  j代表 缺失率；
    end
end
disp(Result);
%Result n*d  n:算法个数  d:数据集个数
