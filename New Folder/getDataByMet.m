function [ Result ] = getDataByMet( metricInd,MissRate)
%
%   
    %MetricName = 'hammingLoss';
    datasets = {'slashdot','medical','enron','health','Science','education','recreation','arts','rcv1subset1_top944'};
    algorithms = {'MLMF\','LLSF\','MLKNN\','LSML-MF\','Glocal-MF\','LSFCI\','CLML\'};
    Result = zeros(7,9);%5���㷨 7�����ݼ�
    for i=1:size(algorithms,2)
        path = ['C:\Users\wsco19\Desktop\Codes\ʵ����\',algorithms{i}];
        for j=1:size(datasets,2)
            filename = [datasets{j},'.xls'];
            path2 = [path,filename];
            dataMatrix = xlsread(path2);
            Result(i,j) = dataMatrix(metricInd ,MissRate);%dataMetrix(i,j) i����metricname  j���� ȱʧ�ʣ�
        end
    end
    %disp(Result);

end

