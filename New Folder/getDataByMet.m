function [ Result ] = getDataByMet( metricInd,MissRate)
%
%   
    %MetricName = 'hammingLoss';
    datasets = {'slashdot','medical','enron','health','Science','education','recreation','arts','rcv1subset1_top944'};
    algorithms = {'MLMF\','LLSF\','MLKNN\','LSML-MF\','Glocal-MF\','LSFCI\','CLML\'};
    Result = zeros(7,9);%5个算法 7个数据集
    for i=1:size(algorithms,2)
        path = ['C:\Users\wsco19\Desktop\Codes\实验结果\',algorithms{i}];
        for j=1:size(datasets,2)
            filename = [datasets{j},'.xls'];
            path2 = [path,filename];
            dataMatrix = xlsread(path2);
            Result(i,j) = dataMatrix(metricInd ,MissRate);%dataMetrix(i,j) i代表metricname  j代表 缺失率；
        end
    end
    %disp(Result);

end

