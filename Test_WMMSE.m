function [iter1, time, rate] = Test_WMMSE(K, T, R, epsilon, sigma2, snr, I, alpha1, d, max_iter)
%TEST_WMMSE 是用来测试WMMSE性能的函数
% 输入函数运行参数，返回迭代次数，运行时间与速率信息
P = db2pow(snr)*sigma2; % 发射功率
rate = []; % 初始化一个空向量记录rate
time = []; % 初始化一个空运行时间记录rate
tic; %开始计时
begin_time = toc; % 标记开始时间，结束时间减去开始时间就是使用的时间
time = [time 0];
% 初始化信道向量
H = cell(I,K,K); % 信道系数
for i=1:I
    for k = 1:K
        for j=1:K
           H{i,k,j}=sqrt(1/2)*(randn(R,T)+1i*randn(R,T)); % 圆复高斯信道
        end
    end
end

U = cell(I,K);
U(:)={zeros(R,d)};

% 随机初始化发射波束向量
V = cell(I,K); % 算法第一行
for i=1:I
    for k=1:K
        v = randn(T,d)+1i*randn(T,d); % 随机初始化
        V{i,k}=sqrt(P/I)*v/norm(v,"fro");
    end
end 

% 求初始化发射波束V后求系统和速率
rate_old = sum_rate1(H,V,sigma2,R,I,K,alpha1);
rate = [rate rate_old];


iter1 = 1;
while(1)
    U = find_U1(H,V,sigma2,R,I,K,d); % Tbale I line 4 in p.4435
    W = find_W1(U,H,V,I,K,d); % Tbale I line 5 in p.4435
    V = find_V1(alpha1,H,U,W,T,I,K,P); % Tbale I line 6 in p.4435
    rate_new = sum_rate1(H,V,sigma2,R,I,K,alpha1);
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

