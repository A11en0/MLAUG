function model = MLAUG( X, Y, optmParameter)
% A���������ݶ��½�������⣬�����Ǿ�ȷ��
    
   %% optimization parameters
    lambda1          = optmParameter.lambda1; %     
    lambda2          = optmParameter.lambda2; %     
    lambda3          = optmParameter.lambda3; % feature correation
    lambda4          = optmParameter.lambda4; % label correlation
    lambda5          = optmParameter.lambda5; % regularization W
    
    rho              = optmParameter.rho;
    
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;
    
    num_dim   = size(X,2);%����X������ ��������
    num_class = size(Y,2);%����Y������ ����ǩ��
    I = eye(num_dim);
    XTX = X'*X;
    XTY = X'*Y;
    YTY = Y'*Y;
    YTX = Y'*X;
    
    disp(' MLAUG');
    %% initialization
    W   = (XTX + rho*eye(num_dim)) \ (XTY); %zeros(num_dim,num_class);
    W_1 = W; W_k = W;
    
    R     = pdist2( Y'+eps, Y'+eps, 'cosine' );%R �õ���ֻ�Ǿ��룬���������ƶ��ǳɷ��ȵ�
    C = 1 - R; %��1��R�õ��ľ������ƶȾ���
    L2 = diag(sum(C,2)) - C;%��ǩ����Ե�������˹����
    
%     W = rand(num_dim, num_class);
%     V = rand(num_class, num_class);
    V = ((XTX + rho*eye(num_dim))\(XTY*W'+lambda1*XTX))/(W*W'+lambda1*I+lambda3*W*L2*W');
    V = max(V,0);
    
    U = ((1 + lambda2)*YTY + rho*eye(num_class)) \ (lambda2*YTY + YTX*V*W);
    U = max(U,0);
    
%     V =( ((XTX + rho*eye(num_dim)) \ (X'*Y*U*W')) + lambda1* eye(num_dim) ) / (W*W' + lambda1*eye(num_dim) + lambda4*W*L2*W');
%     V = (XTX + rho*eye(num_dim)) \ (lambda1*XTX + X'*Y*U*W') / (W * W' + lambda1*I + lambda4*W*L2*W');
    
    iter = 1; oldloss = 0;%Ŀ�꺯������ʧ��  (W*W'+lambda1*I+lambda3*W*L2*W')^-1;
    bk = 1; bk_1 = 1; 
    leaningRate = 0.0000001;  %0.00001
    
    while iter <= maxIter 
      %% update U
       U = U - leaningRate*gradientOfU(U,X,V,W,Y,lambda2);
%        U = U - diag(diag(U));
       U = max(U,0);
       L2 = diag(sum(U,2)) - U;
       
       %% update V
       V = V - leaningRate* gradientOfV(U,V,X,L2,W,Y,lambda1,lambda4);
       V = max(V,0);
       L1 = diag(sum(V,2)) - V;
       
       Lip1 = 3*norm(V'*(X'*X)*V)^2 + 3*norm(lambda3*L1)^2 + 3*norm(lambda4*V'*(X'*X)*V)^2 * norm(L2)^2;       
       Lip = sqrt(Lip1);
       
       %% update W
       %     W = W - leaningRate*  gradientOfW(X,Y,U,V,W,L1,L2,lambda3,lambda4);
       W_k  = W + (bk_1 - 1)/bk * (W - W_1);
       Gw_x_k = W_k - 1/Lip * gradientOfW(X,Y,U,V,W,L1,L2,lambda3,lambda4);
       W_1  = W;
       W    = softthres(Gw_x_k,lambda5/Lip);
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;                                                                                                                                
      %% Loss ��ʼ����ʧ����
       LS = X*V*W - Y*U;
       DiscriminantLoss = trace(LS'* LS);
       LS = X - X*V;
       FeatureAug  = trace(LS'*LS);
       LS = Y - Y*U;
       LabelAug  = trace(LS'*LS);
       FeatureCor = trace(W'*L1*W);
       F = X*V*W;
       labelCor = trace(F*L2*F');
       sparesW    = sum(sum(W~=0));
       
       totalloss = DiscriminantLoss + lambda1*FeatureAug +  lambda2*LabelAug +lambda3*FeatureCor + lambda4*labelCor+lambda5*sparesW;
       loss(iter,1) = totalloss;
       disp(totalloss);
       if abs((oldloss - totalloss)/oldloss) <= miniLossMargin %��õ�W��Cʹ����ʧ������ֵ�ﵽ�������С��ʧֵʱ�����ٵ���
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
    model.U = U;
    model.V = V;
    
    model.loss = loss;
    model.optmParameter = optmParameter;
end

%% soft thresholding operator
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0);  
end

function gradient = gradientOfU(U,X,V,W,Y,lambda2)
    num_size = size(Y,2);
    I = eye(num_size);
    gradient = Y'*Y*((1 - lambda2)*U - lambda2*I) - Y'*X*V*W;
end

function gradient = gradientOfV(U,V,X,L2,W,Y,lambda1,lambda4)
    num_size = size(X,2);
    I = eye(num_size);
    gradient = X'*X*V*(W*W' + lambda1*I + lambda4*W*L2*W') - lambda1*(X'*X) - X'*Y*U*W';
end

function gradient = gradientOfW(X,Y,U,V,W,L1,L2,lambda3,lambda4)
    gradient = V'*X'*(X*V*W - Y*U) + lambda4*V'*X'*X*V*W*L2 + lambda3*L1*W;
end