function predict_target = Predict(Outputs,tau)
%% 
 %Outputs: ��������Ԥ����
 %tau:Ŀǰδ֪����Ӧ����һ������
 
    predict_target = zeros(size(Outputs));%������Ԥ����ͬ����0�������ڴ�����ս��
    num_class = size(Outputs,1);%�õ����ǩ����
    for l = 1:num_class %����ÿ�����ǩ��
        predict_target(l,:) = Outputs(l,:) >= tau(1,l);%����tau()������ֵ�����Ƶ����յ�Ԥ�������
    end
    %predict_target = predict_target*2-1;
end