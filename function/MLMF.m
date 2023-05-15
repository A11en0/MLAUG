
function model = MLMF( X, Y, optmParameter)
% This function is designed to Learn label-Specific Features and Class-Dependent Labels for Multi-Label Classification
% 
%    Syntax
%
%       [model] = LSML( X, Y, optmParameter)
%
%    Input
%       X               - a n by d data matrix, n is the number of instances and d is the number of features 
%       Y               - a n by l label matrix, n is the number of instances and l is the number of labels
%       optmParameter   - the optimization parameters for LSML, a struct variable with several fields, 
%
%    Output
%
%       model    -  a structure variable composed of the model coefficients

   %% optimization parameters
    lambda1          = optmParameter.lambda1; % missing feature
    lambda2          = optmParameter.lambda2; % feature correation
    lambda3          = optmParameter.lambda3; % label correlation
    lambda4          = optmParameter.lambda4; % regularization W
    rho              = optmParameter.rho;
    
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;

    num_dim   = size(X,2);%����X������ ��������
    num_class = size(Y,2);%����Y������ ����ǩ��
    I = eye(num_dim);
    XTX = X'*X;
    XTY = X'*Y;
    YTY = Y'*Y;
    %disp('MLMF');
   %% initialization
    W   = (XTX + rho*eye(num_dim)) \(XTY); %zeros(num_dim,num_class);
    W_1 = W; W_k = W;
    
    R     = pdist2( Y'+eps, Y'+eps, 'cosine' );%R �õ���ֻ�Ǿ��룬���������ƶ��ǳɷ��ȵ�
    C = 1 - R;%��1��R�õ��ľ������ƶȾ���
    L2 = diag(sum(C,2)) - C;%��ǩ����Ե�������˹����
    
    iter = 1; oldloss = 0;%Ŀ�꺯������ʧ��  (W*W'+lambda1*I+lambda3*W*L2*W')^-1;
    bk = 1; bk_1 = 1; 
   
    while iter <= maxIter 
      %% update A
       A = ((XTX + rho*eye(num_dim))\(XTY*W'+lambda1*XTX))/(W*W'+lambda1*I+lambda3*W*L2*W');
       A = max(A,0);
       L1 = diag(sum(A,2)) - A;
       
       Lip1 = 3*norm(A'*X'*X*A)^2 + 3*norm(lambda2*L1)^2 + 3*norm(lambda3*A'*X'*X*A)^2 * norm(L2)^2;
       Lip = sqrt(Lip1);
      %% update W
       W_k  = W + (bk_1 - 1)/bk * (W - W_1);
       Gw_x_k = W_k - 1/Lip * gradientOfW(A,X,Y,L2,W,lambda2,lambda3);
       W_1  = W;
       W    = softthres(Gw_x_k,lambda4/Lip);
       
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;
      
      %% Loss ��ʼ����ʧ����
       LS = X*A*W - Y;
       DiscriminantLoss = trace(LS'* LS);
       LS = X*A - X;
       MissLoss  = trace(LS'*LS);
       FeatureCor = trace(W'*L1*W);
       F = X*A*W;
       labelCor = trace(F*L2*F');
       sparesW    = sum(sum(W~=0));
       totalloss = DiscriminantLoss + lambda1*MissLoss + lambda2*FeatureCor + lambda3*labelCor+lambda4*sparesW;
       ML = lambda1*MissLoss;
       FC = lambda2*FeatureCor;
       LC = lambda3*labelCor;
       SW = lambda4*sparesW;
       loss(iter,1) = totalloss;
       if abs((oldloss - totalloss)/oldloss) <= miniLossMargin %��õ�W��Cʹ����ʧ������ֵ�ﵽ�������С��ʧֵʱ�����ٵ���
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       iter=iter+1;
    end
    model.W = W;
    model.A = A;
    model.loss = loss;
    model.optmParameter = optmParameter;
end

%% soft thresholding operator
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0);  
end

function gradient = gradientOfW(A,X,Y,L2,W,lambda2,lambda3)
    L1 = diag(sum(A,2)) - A;
    gradient = A'*X'*X*A*W - A'*X'*Y + lambda2*L1*W + lambda3*A'*X'*X*A*W*L2;
end




