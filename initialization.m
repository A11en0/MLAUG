% The folow parameter settings are suggested to reproduct most of the 
% experimental results of LSML, and a better performance will be obtained 
% by tuning the parameters.
% -------------------------------------------------------------------------

% Parameters : lambda1, lambda2, lambda3, lambda4 rho   best   
% -------------------------------------------------------------------------
% genbase           : 2^-3, 2^-3, 2^0, 2^-6, 2^2      0.088  0.024  0.019
% medical           : 2^-3, 2^3, 2^-1, 2^-6, 2^0       0.214
% rcv1subset1       : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.676  0.667  0.635
% rcv1subset2       : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.740
% enron             : 2^-3, 2^-3, 2^-3, 2^-6, 2^3      0.628  0.605  0.571
% education         : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.755  0.695                            
% arts              : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.879  0.810                               
% science           : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.866  0.787                               
% recreation        : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.919  0.813                                
% slashdot          : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.413       

% languagelog       : 2^-3, 2^-3, 2^-1, 2^-6, 2^2      1.084 
% cal500            : 2^-3, 2^-3, 2^-1, 2^-6, 2^2       1.183 
% stackex_chemstriy : 2^-3, 2^-3, 2^-1, 2^-6, 2^3       0.816 
% stackex_chess     : 2^-3, 2^-3, 2^-1, 2^-6, 2^3       0.711 
% stackex_cs        : 2^-3, 2^-3, 2^-1, 2^-6, 2^3       0.647 
% Stackex_philosophy: 2^-3, 2^-3, 2^-1, 2^-6, 2^3       0.753

% bibtex            : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      0.589
% delicious         : 2^-3, 2^-3, 2^-1, 2^-6, 2^3      
% -------------------------------------------------------------     
% scene             : 2^-3, 2^-3, 2^-1, 2^-6, 2^0      0.580       
% -------------------------------------------------------------------------
% =======================================================================================


% 2e-1 2^-1 2^-1 2^-2 2^-6


function [optmParameter, modelparameter] =  initialization
    %% ours
    optmParameter.lambda1   =  2^2; %  FeatureAug
    optmParameter.lambda2   =  2^2;  % LabelAug
    optmParameter.lambda3   =    2^-2;  % FeatureCor
    optmParameter.lambda4   =  2^-8; %  labelCor   
    optmParameter.lambda5   =   2^-6; %  sparsity
    
    optmParameter.rho       = 2^0;    % 2^{0,1,2,3} WµÄ³õÊ¼»¯
    
    optmParameter.isBacktracking    = 1; % 0 - LSML, 1 - LSML-P
    
    optmParameter.eta       = 10;
    optmParameter.maxIter           = 30;
    optmParameter.minimumLossMargin = 0.00005; %£¨oldloss - totalloss)/oldloss
    optmParameter.tuneParaOneTime   = 1;
    
   %% Model Parameters
    modelparameter.cv_num             = 5;
end



