

addpath(genpath('.'));
clc%�������̨����
clear
starttime = datestr(now,0);
deleteData  = 0;
[optmParameter, modelparameter] =  initialization;% parameter settings for LSML
model_LSML.optmParameter = optmParameter;
model_LSML.modelparameter = modelparameter;
model_LSML.tuneThreshold = 1;% tune the threshold for mlc
lambda1_range = 2.^[-8:6];
lambda2_range = 2.^[-3:-3];
lambda3_range = 2.^[-1:-1];
lambda4_range = 2.^[-6:-6];
totalNum = length(lambda1_range)*length(lambda2_range)*length(lambda3_range)*length(lambda4_range);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load the dataset, you can download the other datasets from our website
load('Science.mat');
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
missRate = 0.3;
data = getMissingFeature(data,missRate,0);%����ȱʧ����


data      = double (data);
num_data  = size(data,1);%��ȡ����
temp_data = data + eps;
temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
if sum(sum(isnan(temp_data)))>0
    temp_data = data+eps;
    temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
end
temp_data = [temp_data,ones(num_data,1)];

randorder = randperm(num_data);%����������������

index = 0;
CurrentResult = zeros(16,2);
BestResult = zeros(16,2);
%%
for a = 1:length(lambda1_range)
   for b = 1:length(lambda2_range)
      for c=1:length(lambda3_range)
         for d=1:length(lambda4_range)
             index = index+1;
             fprintf('��%d����٣���%d��\n',index,totalNum);
             optmParameter.lambda1 = lambda1_range(a);
             optmParameter.lambda2 = lambda2_range(b);
             optmParameter.lambda3 = lambda3_range(c);
             optmParameter.lambda4 = lambda4_range(d);
             fprintf('lamnda1-4=%.4f, %.4f,%.4f,%.4f\n',lambda1_range(a),lambda2_range(b),lambda3_range(c),lambda4_range(d));
             cvResult  = zeros(16,modelparameter.cv_num);%����������ÿ��CV�������ָ��
             for j = 1:modelparameter.cv_num
                %����ÿ�ν�����֤��
                fprintf('Cross Validation - %d/%d',j, modelparameter.cv_num);
                %�������ѵ��������֤�� 
                [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(temp_data,target',randorder,j,modelparameter.cv_num);
     
               %% Training
                modelLSML  = MLMF( cv_train_data, cv_train_target ,optmParameter); 
               %% Prediction and evaluation
                Outputs = (cv_test_data*modelLSML.A*modelLSML.W)';%������Ԥ����
                if model_LSML.tuneThreshold == 1   
                    fscore                 = (cv_train_data*modelLSML.A*modelLSML.W)';
                    [ tau,  currentResult] = TuneThreshold( fscore, cv_train_target', 1, 2);
                    Pre_Labels             = Predict(Outputs,tau);%ɾѡ����õ����յ�Ԥ����
                else
                    Pre_Labels = double(Outputs>=0.5);
                end
                fprintf('-- Evaluation\n');
                tmpResult = EvaluationAll(Pre_Labels,Outputs,cv_test_target');%������е�����ָ���ֵ
                cvResult(:,j) = cvResult(:,j) + tmpResult;%��¼
             end
             CurrentResult(:,1) = mean(cvResult,2);%���н���ȡƽ�� matlab��1����  2 ����
             CurrentResult(:,2) = std(cvResult,1,2);
             SumCurr= CurrentResult(2,1) + CurrentResult(5,1)  + CurrentResult(10,1) + CurrentResult(11,1);
             SumBest = BestResult(2,1) + BestResult(5,1) + BestResult(10,1) + BestResult(11,1);
             if(SumCurr>SumBest)
                 BestResult = CurrentResult;
                 PrintResults(BestResult);
                 fprintf('SumBest=%.3f\n',SumCurr);
                 BestParameter = optmParameter;
             end
         end 
      end   
   end
end
endtime = datestr(now,0);
                  %.3f  %.3f\n',SumOfMetrics);
