function [ F ] = calF_f(K,N,R)
%CALF_F 此处显示有关此函数的摘要
%   此处显示详细说明
sum = 0;
for i= 1:K
    x = R(i);
    sum = sum + x^2;
end
fprintf('Sum=%f\n',sum);

PartOne = 12*N/(K*(K+1));
PartTwo = sum - K*(K+1)*(K+1)/4;
X_F = PartOne * PartTwo;
fprintf('partOne=%f\n',PartOne);
fprintf('PartTwo=%f\n',PartTwo);
fprintf('X_F=%f\n',X_F);
F = ((N-1)*X_F)/(N*(K-1)-X_F);


end

