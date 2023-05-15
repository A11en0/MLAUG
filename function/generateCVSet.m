function [ train_x,train_y,test_x,test_y ] = generateCVSet( X,Y,kk,index,totalCV )
% X: n by d data matrix
% Y: n by l label matrix
% kk = randperm(size(X,1));随机打乱数据集的行数，kk代表的是索引值
% for cv = 1 : totalCV
%     [ train_x,train_y,test_x,test_y ] = generateCVSet( X,Y,kk,cv, totalCV);
%assert 确保括号内条件成立 否则停止运行
    assert(index <= 10);
    assert(totalCV <= 10);
    %返回X矩阵的行数
    m = size(X,1);
    %得到每一份含有的数据集的个数
    slice = ceil(m/totalCV);
    %随机选择slice个样本作为测试集
    test_x = X(kk((index - 1) * slice + 1: min( index * slice , m ) ) ,:);
    test_y = Y(kk((index - 1) * slice + 1: min( index * slice , m ) ) ,:);
    
    %其余样本作为训练集
    train_x = X(setdiff(kk,kk((index - 1) * slice + 1: min( index * slice , m ) )),:);
    train_y = Y(setdiff(kk,kk((index - 1) * slice + 1: min( index * slice , m ) )),:);

end