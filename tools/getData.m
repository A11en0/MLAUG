function [ Data ] = getData( filename )
%DATA 按照数据集读取数据


algorithms = {'MLMF\','LLSF\','MLKNN\','LSML-MF\','Glocal-MF\','LSFCI\','CLML\'};
num = length(algorithms);
Data = cell(num,1);

for i=1:length(algorithms)
    path = ['C:\Users\HeLu\Desktop\',algorithms{i}];
    path2 = [path,filename,'.xls']; 
    dataMatrix = xlsread(path2);
    Data{i,1} = dataMatrix; 
    %disp(dataMatrix);
end

end


