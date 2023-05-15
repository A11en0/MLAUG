function [ X ,realpercent] = getMissingFeature( X, percent, bQuiet )
%
% delete the elements in the target matrix 'oldtarget' by the given percent
% oldtarget : N by L data matrix
% percent   : 10%, 20%, 30%, 40%, 50%
% 

%����һ����ȫΪ1Ԫ�صı�ǩ����
obsTarget_index = ones(size(X));

totoalNum = sum(sum(X ~=0));%ʵ����صı�ǩ�� sum(x):��x�������
totoaldeleteNum = 0;
[N,~] = size(X);%���ѵ������������
realpercent = 0;
maxIteration = 50;
factor = 2;
count=0;
while realpercent < percent
    %�������50��֮�����޷�����ȱʧ�ʣ���factor��Ϊ1���ٵ���100��
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
    for i=1:N %����ѵ������ÿһ��������
        index = find(X(i,:)~=0);%��������i�ı�ǩ����1������ֵ(�������Ǵ�1��ʼ ���Ǵ�0��ʼ)
        if length(index) >= factor % factor can be set to be 1 if the real missing rate can not reach the pre-set value
            deleteNum = round(rand*(length(index)-1));%���ٱ�֤�������и�����ǩ  ���ȷ��Ҫɾ���ı�ǩ����
            totoaldeleteNum = totoaldeleteNum + deleteNum;
            realpercent = totoaldeleteNum/totoalNum;
            
            if deleteNum > 0
                index = index(randperm(length(index)));%��index������������д��ң�Ŀ���������ѡ��deleteNUm����ǩɾ��
                X(i,index(1:deleteNum)) = 0;%����ȱʧ��ǩ
                obsTarget_index(i,index(1:deleteNum))=0;
            end
            
            if realpercent >= percent
                %����ȱʧҪ������ѭ��
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

