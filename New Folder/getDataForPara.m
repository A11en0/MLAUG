function [ Data ] = getDataForPara( paraName )
%DATA 按照数据集读取数据

% algorithms = {'MLMF\','LLSF\','MLKNN\','LSML-MF\','Glocal-MF\','LSFCI\','CLML\'};

datasets = {'Emotions', 'Scene','Yeast'};
num = length(datasets);
Data = cell(num,1);

for i=1:length(datasets)
    path = ['C:\Users\wsco19\Desktop\Codes\Deep-MVML-Newest\para_results\',datasets{i}];
    path2 = [path,'\stat-', paraName, '.csv']; 
    dataMatrix = xlsread(path2);
    Data{i,1} = dataMatrix; 
    %disp(dataMatrix);
end

end
