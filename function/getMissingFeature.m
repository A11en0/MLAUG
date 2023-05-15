function [ X ,realpercent] = getMissingFeature( X, percent, bQuiet )
%
% delete the elements in the target matrix 'oldtarget' by the given percent
% oldtarget : N by L data matrix
% percent   : 10%, 20%, 30%, 40%, 50%
% 

%构造一个与全为1元素的标签矩阵
obsTarget_index = ones(size(X));

totoalNum = sum(sum(X ~=0));%实际相关的标签数 sum(x):对x的列求和
totoaldeleteNum = 0;
[N,~] = size(X);%获得训练集的样本数
realpercent = 0;
maxIteration = 50;
factor = 2;
count=0;
while realpercent < percent
    %如果迭代50次之后还是无法满足缺失率，将factor置为1，再迭代100次
    if maxIteration == 0
        factor = 1;
        maxIteration = 10;
        if count==1
            break;
        end
        count = count+1;
    else
        maxIteration = maxIteration - 1;
    end
    for i=1:N %对于训练集的每一个样本：
        index = find(X(i,:)~=0);%返回样本i的标签集中1的索引值(索引都是从1开始 并非从0开始)
        if length(index) >= factor % factor can be set to be 1 if the real missing rate can not reach the pre-set value
            deleteNum = round(rand*(length(index)-1));%至少保证该样本有个类别标签  随机确定要删除的标签个数
            totoaldeleteNum = totoaldeleteNum + deleteNum;
            realpercent = totoaldeleteNum/totoalNum;
            
            if deleteNum > 0
                index = index(randperm(length(index)));%将index中索引随机进行打乱，目的在于随机选择deleteNUm个标签删除
                X(i,index(1:deleteNum)) = 0;%制造缺失标签
                obsTarget_index(i,index(1:deleteNum))=0;
            end
            
            if realpercent >= percent
                %满足缺失要求，跳出循环
                break;
            end
        end
    end
end

if bQuiet == 0
    fprintf('\n  Totoal Number of Feature Entities : %d\n ',totoalNum);  
    fprintf('Number of Deleted Feature Entities : %d\n ',totoaldeleteNum);  
    fprintf('        Given percent/Real percent : %.2f / %.2f\n', percent,totoaldeleteNum/totoalNum);  
end

end

