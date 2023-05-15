%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is MLMF  Multi label learning with missing features  IJCNN 2021
% lastest update time is 2021/11.26 by first author 
% 
%'languagelog','cal500','stackex_chemistry','stackex_chess','stackex_philosophy','stackex_cs'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('.'));
clc%清除控制台命令
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
%% target 变为 （0 1）数据而非 （-1 1）
target = double(target>0);
data      = double (data);
num_data  = size(data,1);%获取行数
randorder = randperm(num_data);%将样本序号随机打乱
cvResult  = zeros(16,modelparameter.cv_num);%构建矩阵存放每次CV后的评价指标
%% five-cross
for j = 1:modelparameter.cv_num    

    %对于每次交叉验证：
    fprintf('\nCross Validation - %d/%d',j, modelparameter.cv_num);
    %% 随机划分训练集与验证集 
    [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data,target',randorder,j,modelparameter.cv_num);
    %% 预处理
    cv_train_data = Pre_process(cv_train_data);  %In_train_data = Pre_process(In_train_data);
    cv_test_data = Pre_process(cv_test_data);
    %% Training
    model  = MLAUG(cv_train_data, cv_train_target ,optmParameter); 
    %         model  = MLMF2(cv_train_data, cv_train_target ,optmParameter); 
    
    %% Prediction and evaluation
    Outputs = (cv_test_data*model.V*model.W)';%初步的预测结果
    if model_LSML.tuneThreshold == 1   
        fscore                 = (cv_train_data*model.V*model.W)';
        [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 1);
        Pre_Labels             = Predict(Outputs,tau);%删选结果得到最终的预测结果
    else
        Pre_Labels = double(Outputs>=0.5);
    end
    fprintf('-- Evaluation\n');
    tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%获得所有的评价指标的值PrintResults(Avg_Result);
    cvResult(:,j) = cvResult(:,j) + tmpResult;%记录
%     PrintResults(cvResult / j);
%     break
end

endtime = datestr(now,0);
Avg_Result      = zeros(16,2);
Avg_Result(:,1) = mean(cvResult,2);%对行进行取平均 matlab中1：列  2 ：行
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
