%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is an examplar file on how the LSML [1,2] program could be used.
%
% [1] J. Huang, F. Qin, X. Zheng, Z. Cheng, Z. Yuan, W. Zhang, and Q. Huang. Improving Multi-Label Classification 
%     with Missing Labels by Learning Label-Specific Features, Information Sciences: 2019 ,492 ,124-146
% [2] J. Huang, F. Qin, X. Zheng, Z. Cheng, Z. Yuan, and W. Zhang. Learning Label-Specific Features for 
%     Multi-Label Classification with Missing Labels, IEEE BigMM: 2018 ,1-5
%
% The experimental datasets are also available at http://www.escience.cn/people/huangjun/index.html
% 
% Please feel free to contact me (huangjun.cs@ahut.edu.cn), if you have any problem about this programme.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('.'));
clc%�������̨����
clear
starttime = datestr(now,0);
deleteData  = 0;
[optmParameter, modelparameter] =  initialization;% parameter settings for 
model_LSML.optmParameter = optmParameter;
model_LSML.modelparameter = modelparameter;
model_LSML.tuneThreshold = 1;% tune the threshold for mlc

fprintf('lamda1=%f\n',optmParameter.lambda1);
fprintf('lamda2=%f\n',optmParameter.lambda2);
fprintf('lamda3=%f\n',optmParameter.lambda3);
fprintf('lamda4=%f\n',optmParameter.lambda4);
fprintf('lamda5=%f\n',optmParameter.lambda5);

%fprintf('*** run LSML for multi-label learning with missing labels ***\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%'medical','enron','slashdot'
datasets = {'bibtex','delicious','health','emotions','core15k','scene','medical','enron'};
%'recreation','education','arts','science','health','rcv1subset1_top944','rcv1subset2_top944',
% datasets = {'slashdot', 'recreation', 'education', 'arts', 'health','rcv1subset1_top944','rcv1subset2_top944'};  % slashdot
%% load the dataset, you can download the other datasets from our website
for it=1:size(datasets,2)
%     rng(43);
    dataname = ['data/',datasets{it},'.mat'];
    filename = datasets{it};
    fprintf('This data is %s\n',filename);
    saveResult = zeros(16,2);
    
    load(dataname);
        if exist('train_data','var')==1
            data=[train_data;test_data];
            target=[train_target,test_target];    
            clear train_data test_data train_target test_target
        end
        if exist('dataset','var')==1
            data = dataset;
            target = class ;
            clear dataset class
        end
        %% target ��Ϊ 0-1����
        target = double(target>0);
        data      = double (data);
        num_data  = size(data,1);%��ȡ����
        randorder = randperm(num_data);%����������������
        cvResult  = zeros(16,modelparameter.cv_num);%����������ÿ��CV�������ָ��
        %% five-cross
        for j = 1:modelparameter.cv_num
            %����ÿ�ν�����֤��
            fprintf('MLMF Cross Validation - %d/%d',j, modelparameter.cv_num);
            %�������ѵ��������֤�� 
            [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data,target',randorder,j,modelparameter.cv_num);
            %% Ԥ����
            cv_train_data = Pre_process(cv_train_data); cv_test_data = Pre_process(cv_test_data);
            %% Training
            model  = MLAUG(cv_train_data, cv_train_target ,optmParameter); 
            %% Prediction and evaluation
            Outputs = (cv_test_data*model.V*model.W)';%������Ԥ����
            if model_LSML.tuneThreshold == 1   
                fscore                 = (cv_train_data*model.V*model.W)';
                [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 1);
                Pre_Labels             = Predict(Outputs,tau);%ѡ����õ����յ�Ԥ����
            else
                Pre_Labels = double(Outputs>=0.5);
            end
            fprintf('-- Evaluation\n');
            tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%������е�����ָ���ֵ
            cvResult(:,j) = cvResult(:,j) + tmpResult;%��¼
        end
        saveResult(:,1) = mean(cvResult,2);
        saveResult(:,2) = std(cvResult,1,2);
        path = ['.\MLAUG\',filename];
        xlswrite(path,saveResult)
end

%         saveResult = mean(cvResult,2);
% disp(saveResult);

endtime = datestr(now,0);
