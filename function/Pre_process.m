function [ temp_data ] = Pre_process( data )
%PRE-PROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
%% 预处理
data      = double (data);
num_data  = size(data,1);%获取行数
temp_data = data + eps;
temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
if sum(sum(isnan(temp_data)))>0
    temp_data = data+eps;
    temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
end
temp_data = [temp_data,ones(num_data,1)];


end

