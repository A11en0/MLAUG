function model = MLMF2( X, Y, optmParameter)
% A矩阵利用梯度下降进行求解，而不是精确解

   %% optimization parameters
    lambda1          = optmParameter.lambda1; % missing feature
    lambda2          = optmParameter.lambda2; % feature correation
    lambda3          = optmParameter.lambda3; % label correlation
    lambda4          = optmParameter.lambda4; % regularization W
    rho              = optmParameter.rho;
    
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;

    num_dim   = size(X,2);%返回X的列数 即特征数
    num_class = size(Y,2);%返回Y的列数 即标签数
    I = eye(num_dim);
    XTX = X'*X;
    XTY = X'*Y;
    YTY = Y'*Y;
    disp('MLMF2');
   %% initialization
    W   = (XTX + rho*eye(num_dim)) \(XTY); %zeros(num_dim,num_class);
    W_1 = W; W_k = W;
    
    R     = pdist2( Y'+eps, Y'+eps, 'cosine' );%R 得到的只是距离，距离与相似度是成反比的
    C = 1 - R;%用1—R得到的就是相似度矩阵
    L2 = diag(sum(C,2)) - C;%标签相关性的拉普拉斯矩阵
    
    A = ((XTX + rho*eye(num_dim))\(XTY*W'+lambda1*XTX))/(W*W'+lambda1*I+lambda3*W*L2*W');
%     A = rand(num_dim, num_dim);    
    A = max(A,0);
    
    iter = 1; oldloss = 0;%目标函数的损失度  (W*W'+lambda1*I+lambda3*W*L2*W')^-1;
    bk = 1; bk_1 = 1; 
    leaningRate = 0.00001;  %0.00001
   
    while iter <= maxIter 
      %% update A
       A = A - leaningRate*gradientOfA(A,X,XTX,L2,W,Y,lambda1,lambda3);
       A = max(A,0);
       L1 = diag(sum(A,2)) - A;
       Lip1 = 3*norm(A'*X'*X*A)^2 + 3*norm(lambda2*L1)^2 + 3*norm(lambda3*A'*X'*X*A)^2 * norm(L2)^2;
       Lip = sqrt(Lip1);
      %% update W
      %    W = W - leaningRate*gradientOfW(A,X,Y,L2,W,lambda2,lambda3);
       W_k  = W + (bk_1 - 1)/bk * (W - W_1);
       Gw_x_k = W_k - 1/Lip * gradientOfW(A,X,Y,L2,W,lambda2,lambda3);
       W_1  = W;
       W    = softthres(Gw_x_k,lambda4/Lip);
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;                                                                                                                                
      %% Loss 初始的损失函数
       LS = X*A*W - Y;
       DiscriminantLoss = trace(LS'* LS);
       LS = X*A - X;
       MissLoss  = trace(LS'*LS);
       FeatureCor = trace(W'*L1*W);
       F = X*A*W;
       labelCor = trace(F*L2*F');
       sparesW    = sum(sum(W~=0));
       totalloss = DiscriminantLoss + lambda1*MissLoss + lambda2*FeatureCor + lambda3*labelCor+lambda4*sparesW;
       loss(iter,1) = totalloss;
       if abs((oldloss - totalloss)/oldloss) <= miniLossMargin %求得的W和C使得损失函数的值达到定义的最小损失值时，不再迭代
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       iter=iter+1;
    end
    fprintf('iteration times - %d',iter);
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

function gradient = gradientOfA(A,X,XTX,L2,W,Y,lambda1,lambda3)
    num_size = size(X,2);
    I = eye(num_size);
    gradient = XTX*A*(W*W'+lambda1*I+lambda3*W*L2*W')-X'*Y*W'-lambda1*XTX;
end




