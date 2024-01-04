function [iter1, time, rate] = Test_R_WMMSE(K, T, R, epsilon, sigma2, snr, I, alpha1, d, max_iter)
%TEST_R_WMMSE 是用来测试R-WMMSE性能的函数
% 输入函数运行参数，返回迭代次数，运行时间与速率信息
P = db2pow(snr)*sigma2; % 发射功率
rate = []; % 初始化一个空速率记录rate
time = []; % 初始化一个空运行时间记录rate
tic; %开始计时
begin_time = toc; % 标记开始时间，结束时间减去开始时间就是使用的时间
time = [time 0];
% 初始化信道向量
H = zeros(R,T,I); % 信道系数 用户数量*每个用户天线数量*基站天线数量
% 把所有用户的信道矩阵拼接以第一个维度拼接起来
H_full = zeros(I*R,T);
for i=1:I
    H(: , :, i)=sqrt(1/2)*(randn(R,T)+1i*randn(R,T)); % 圆复高斯信道
    H_full((i-1)*R+1:i*R,:)=H(:,:, i);
end

% 计算H_hat = H_full*H_full'
H_hat = H_full*H_full';

% 初始化W和U矩阵
U =randn(R,d,I) + 1j*randn(R,d,I);
W = zeros(d,d,I);
for i=1:I
    W(:,:,i)=eye(d,d);
end

% 用低维度的坍塌矩阵X代替波束赋形矩阵，V = H'*X, 随机初始化X
X = zeros(R*I,d,I); % 每个基站的坍塌波束赋形矩阵
V = zeros(T,d,I); % 每个基站的波束赋形矩阵
for i=1:I
        x = sqrt(1/2)*(randn(R*I,d)+1i*randn(R*I,d)); % 随机初始化低维度的坍塌矩阵X
        v = H_full'*x;
        X(:,:, i) = sqrt(P/(I*trace(H_hat*x*x')))*x;
        V(:,:, i) = H_full'*X(:,:,i);
end 

% 求初始化发射波束V后求系统和速率
rate_old = sum_rate(H,V,sigma2,R,I,alpha1);
rate = [rate rate_old];

iter1 = 1;
while(1)
    U = find_U(H_hat,X,sigma2, P, R,I,d); % R-WMMSE公式24
    W = find_W(U,H_hat,X, R , I,d); % R-WMMSE公式25
    X = find_X(alpha1,H_hat,sigma2,U,W,T, R, I,d ,P); % R-WMMSE公式26
    
    % 计算放缩系数beta
    beta = 0; 

    for i = 1:I
        beta = beta + trace(H_hat*X(:,:,i)*(X(:,:,i)'));
    end

    beta = P / beta;
    
    % 计算真正的波束赋形向量
    for i = 1:I
        V(:,:,i) = sqrt(beta) * H_full'*X(:,:,i);
    end


    rate_new = sum_rate(H,V,sigma2,R,I,alpha1); % 计算和速率
    rate = [rate rate_new];
    elapsed_time = toc;
    elapsed_time = elapsed_time - begin_time;
    time = [time elapsed_time];
    iter1 = iter1 + 1;
    if abs(rate_new-rate_old) / rate_old < epsilon || iter1 > max_iter
        break;
    end
    rate_old = rate_new;
end


end

