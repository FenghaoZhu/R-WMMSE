clc;clear;
K = 1; % 基站个数，此版本固定为1
T = 512; % 发射天线个数
R = 4; % 接收天线个数
epsilon = 1e-3; % 收敛条件
sigma2 = 1; % 噪声功率
snr = 10; % 信噪比
P = db2pow(snr)*sigma2; % 发射功率
I = 16; % 用户个数
alpha1 = ones(I,K); % 权重系数，都假设相同
d = 4; % 假设每个用户都有d条路独立的数据流
max_iter = 100;
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

% plot(0:iter1-1,rate,'r-o')
% grid on
% xlabel('Iterations')
% ylabel('Sum rate (bits per channel use)')
% set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1)
% title('R-WMMSE, K=1, T=128, R=4, D=4, \epsilon=1e-3','Interpreter','tex')
% title('SISO-IFC, K=3, T=1, R=1, \epsilon=1e-3','Interpreter','tex')