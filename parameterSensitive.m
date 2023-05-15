addpath(genpath('.'));
clc%清除控制台命令
clear
starttime = datestr(now,0);
deleteData  = 0;
[optmParameter, modelparameter] =  initialization;% parameter settings for LSML
raw_optm = optmParameter;
model_LSML.optmParameter = optmParameter;
model_LSML.modelparameter = modelparameter;
model_LSML.tuneThreshold = 1;% tune the threshold for mlc
range = 2.^[-8:2:6];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load the dataset, you can download the other datasets from our website

% datasets = {'genbase','slashdot', 'recreation', 'education'}; 
datasets = {'delicious','health','emotions','yeast'};
% datasets = {'health','rcv1subset1_top944','rcv1subset2_top944', 'arts'};
% datasets = {'core15k','scene','medical','enron','image','science'};

for it=1:length(datasets)
    rng(43);
    dataname = ['data/',datasets{it},'.mat'];
    filename = datasets{it};
    fprintf('This data is %s\n',filename);
    saveResult = zeros(16,2);
    
    pathfold = ['.\paraSen\', filename];
    if exist(pathfold) == 0
        mkdir(pathfold)
    else
        disp('Directory Exist!')
    end
    
    load([filename, '.mat']);
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
    %     cvResult  = zeros(16,modelparameter.cv_num);%构建矩阵存放每次CV后的评价指标
    %%
    lambdas = {'lambda1','lambda2','lambda3','lambda4','lambda5'};
    for  i = 1:length(lambdas)
        lambda = lambdas{i};
        disp(lambda);
        optmParameter = raw_optm;
        index = 0;
        Result  = zeros(16,length(range));
        for a = 1:length(range)
         %更新参数的值
         optmParameter = setfield(optmParameter, lambda, range(a));
         fprintf('lambda1-5=%.4f, %.4f,%.4f,%.4f,%.4f\n',optmParameter.lambda1,optmParameter.lambda2,optmParameter.lambda3,optmParameter.lambda4,optmParameter.lambda5);
         cvResult  = zeros(16,modelparameter.cv_num);%构建矩阵存放每次CV后的评价指标
         
         parfor j = 1:modelparameter.cv_num
%             break;
            %对于每次交叉验证：
            fprintf('Cross Validation - %d/%d',j, modelparameter.cv_num);
            %随机划分训练集与验证集 
            [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data,target',randorder,j,modelparameter.cv_num);
            %% 预处理
            cv_train_data = Pre_process(cv_train_data);  %In_train_data = Pre_process(In_train_data);
            cv_test_data = Pre_process(cv_test_data);
           %% Training
           
            model  = MLAUG(cv_train_data, cv_train_target ,optmParameter); 
            
            %% Prediction and evaluation
            Outputs = (cv_test_data*model.V*model.W)';%初步的预测结果
            if model_LSML.tuneThreshold == 1   
                fscore                 = (cv_train_data*model.V*model.W)';
                [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 2);
                Pre_Labels             = Predict(Outputs,tau);%删选结果得到最终的预测结果
            else
                Pre_Labels = double(Outputs>=0.5);
            end
            fprintf('-- Evaluation\n');
            tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%获得所有的评价指标的值
            cvResult(:,j) = cvResult(:,j) + tmpResult;%记录
         end
         index = index+1;
         Result(:,index) = mean(cvResult,2);%对行进行取平均 matlab中1：列  2 ：行
         %CurrentResult(:,2) = std(cvResult,1,2);
        end
        path = ['.\paraSen\', filename, '\', lambda, '.xls'];
        disp(path);
        xlswrite(path,Result);
%         disp(Result);
        endtime = datestr(now,0);
    end
end