function predict_target = Predict(Outputs,tau)
%% 
 %Outputs: 分类器的预测结果
 %tau:目前未知，但应该是一种条件
 
    predict_target = zeros(size(Outputs));%构造与预测结果同样的0矩阵用于存放最终结果
    num_class = size(Outputs,1);%得到类标签个数
    for l = 1:num_class %对于每个类标签：
        predict_target(l,:) = Outputs(l,:) >= tau(1,l);%满足tau()条件的值被复制到最终的预测矩阵中
    end
    %predict_target = predict_target*2-1;
end