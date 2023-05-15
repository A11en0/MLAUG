%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is MLMF  Multi label learning with missing features  IJCNN 2021
% lastest update time is 2021/11.26 by first author 
% 
%'languagelog','cal500','stackex_chemistry','stackex_chess','stackex_philosophy','stackex_cs'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('.'));
clc%�������̨����
clear
starttime = datestr(now,0);
deleteData  = 0;
[optmParameter, modelparameter] =  initialization;% parameter settings for LSML
model_LSML.optmParameter = optmParameter;
model_LSML.modelparameter = modelparameter;
model_LSML.tuneThreshold = 1;% tune the threshold for mlc
fprintf('lamda1=%f\n',optmParameter.lambda1);
fprintf('lamda2=%f\n',optmParameter.lambda2);
fprintf('lamda3=%f\n',optmParameter.lambda3);
fprintf('lamda4=%f\n',optmParameter.lambda4);
fprintf('lamda5=%f\n',optmParameter.lambda5);
%     rng(43);
%fprintf('*** run LSML for multi-label learning with missing labels ***\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load the dataset, you can download the other datasets from our website
filename = 'emotions';
load([filename,'.mat']);   % education enron
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
%% target ��Ϊ ��0 1�����ݶ��� ��-1 1��
target = double(target>0);
data      = double (data);
num_data  = size(data,1);%��ȡ����
randorder = randperm(num_data);%����������������
cvResult  = zeros(16,modelparameter.cv_num);%����������ÿ��CV�������ָ��
%% five-cross
for j = 1:modelparameter.cv_num    

    %����ÿ�ν�����֤��
    fprintf('\nCross Validation - %d/%d',j, modelparameter.cv_num);
    %% �������ѵ��������֤�� 
    [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data,target',randorder,j,modelparameter.cv_num);
    %% Ԥ����
    cv_train_data = Pre_process(cv_train_data);  %In_train_data = Pre_process(In_train_data);
    cv_test_data = Pre_process(cv_test_data);
    %% Training
    model  = MLAUG(cv_train_data, cv_train_target ,optmParameter); 
    %         model  = MLMF2(cv_train_data, cv_train_target ,optmParameter); 
    
    %% Prediction and evaluation
    Outputs = (cv_test_data*model.V*model.W)';%������Ԥ����
    if model_LSML.tuneThreshold == 1   
        fscore                 = (cv_train_data*model.V*model.W)';
        [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 1);
        Pre_Labels             = Predict(Outputs,tau);%ɾѡ����õ����յ�Ԥ����
    else
        Pre_Labels = double(Outputs>=0.5);
    end
    fprintf('-- Evaluation\n');
    tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%������е�����ָ���ֵPrintResults(Avg_Result);
    cvResult(:,j) = cvResult(:,j) + tmpResult;%��¼
%     PrintResults(cvResult / j);
%     break
end

endtime = datestr(now,0);
Avg_Result      = zeros(16,2);
Avg_Result(:,1) = mean(cvResult,2);%���н���ȡƽ�� matlab��1����  2 ����
Avg_Result(:,2) = std(cvResult,1,2);
model_LSML.avgResult = Avg_Result;
model_LSML.cvResult  = cvResult;
PrintResults(Avg_Result);
% saveResult(:,1) = mean(cvResult,2);
% saveResult(:,2) = std(cvResult,1,2);
path = ['.\MLAUG\',filename];
xlswrite([path,'.xls'],Avg_Result)
SumOfMetrics = Avg_Result(1,1)+Avg_Result(13,1)+Avg_Result(14,1)+Avg_Result(15,1);
fprintf('SumOfMetrics                   %.3f  %.3f\n',SumOfMetrics);
