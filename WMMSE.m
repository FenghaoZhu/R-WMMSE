clc;clear;
K = 1; % 基站个数
T = 128; % 发射天线个数
R = 4; % 接收天线个数
epsilon = 1e-3; % 收敛条件
sigma2 = 1; % 噪声功率
snr = 30; % 信噪比
P = db2pow(snr)*sigma2; % 发射功率

I = 4; % 每个基站服务的用户个数
alpha1 = ones(I,K); % 权重系数，都假设相同

d = 1; % 假设每个用户有d条路独立的数据流
max_iter = 100;
tic;
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
toc
% plot(0:iter1-1,rate,'r-o')
% grid on
% xlabel('Iterations')
% ylabel('Sum rate (bits per channel use)')
% set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1)
% title('MIMO-IFC, K=4, T=3, R=2, \epsilon=1e-3','Interpreter','tex')
%title('SISO-IFC, K=3, T=1, R=1, \epsilon=1e-3','Interpreter','tex')