addpath(genpath('.'));
clc%�������̨����
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
    
    %% target ��Ϊ ��0 1�����ݶ��� ��-1 1��
    target = double(target>0);
    data      = double (data);
    num_data  = size(data,1);%��ȡ����
    randorder = randperm(num_data);%����������������
    %     cvResult  = zeros(16,modelparameter.cv_num);%����������ÿ��CV�������ָ��
    %%
    lambdas = {'lambda1','lambda2','lambda3','lambda4','lambda5'};
    for  i = 1:length(lambdas)
        lambda = lambdas{i};
        disp(lambda);
        optmParameter = raw_optm;
        index = 0;
        Result  = zeros(16,length(range));
        for a = 1:length(range)
         %���²�����ֵ
         optmParameter = setfield(optmParameter, lambda, range(a));
         fprintf('lambda1-5=%.4f, %.4f,%.4f,%.4f,%.4f\n',optmParameter.lambda1,optmParameter.lambda2,optmParameter.lambda3,optmParameter.lambda4,optmParameter.lambda5);
         cvResult  = zeros(16,modelparameter.cv_num);%����������ÿ��CV�������ָ��
         
         parfor j = 1:modelparameter.cv_num
%             break;
            %����ÿ�ν�����֤��
            fprintf('Cross Validation - %d/%d',j, modelparameter.cv_num);
            %�������ѵ��������֤�� 
            [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data,target',randorder,j,modelparameter.cv_num);
            %% Ԥ����
            cv_train_data = Pre_process(cv_train_data);  %In_train_data = Pre_process(In_train_data);
            cv_test_data = Pre_process(cv_test_data);
           %% Training
           
            model  = MLAUG(cv_train_data, cv_train_target ,optmParameter); 
            
            %% Prediction and evaluation
            Outputs = (cv_test_data*model.V*model.W)';%������Ԥ����
            if model_LSML.tuneThreshold == 1   
                fscore                 = (cv_train_data*model.V*model.W)';
                [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 2);
                Pre_Labels             = Predict(Outputs,tau);%ɾѡ����õ����յ�Ԥ����
            else
                Pre_Labels = double(Outputs>=0.5);
            end
            fprintf('-- Evaluation\n');
            tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%������е�����ָ���ֵ
            cvResult(:,j) = cvResult(:,j) + tmpResult;%��¼
         end
         index = index+1;
         Result(:,index) = mean(cvResult,2);%���н���ȡƽ�� matlab��1����  2 ����
         %CurrentResult(:,2) = std(cvResult,1,2);
        end
        path = ['.\paraSen\', filename, '\', lambda, '.xls'];
        disp(path);
        xlswrite(path,Result);
%         disp(Result);
        endtime = datestr(now,0);
    end
end