function V = find_V1(alpha1,H,U,W,T,I,K,P)
    V = cell(I,K);
    A = cell(K);
    A(:) = {zeros(T,T)};
    

    for k=1:K   % 公式15括号内求和部分     
        for j=1:K
            for l=1:I
                A{k} = A{k} + alpha1(l,j)*H{l,j,k}'*U{l,j}*W{l,j}*(U{l,j}')*H{l,j,k};
            end
        end   
    end 
    
    max_iter = 100; % 二分法查找最优对偶变量\mu
    mu = zeros(K,1);
    for k=1:K % 对每个基站迭代寻找最优\mu
        mu_min = 0;
        mu_max = 10;
        iter = 0;
        while(1)
            mu1 = (mu_max+mu_min) / 2;
            P_tem = 0;
            for i=1:I % 计算功率和
                V_tem = inv((A{k}+mu1*eye(T)))*alpha1(i,k)*((H{i,k,k}')*U{i,k}*W{i,k}); % 公式15
                P_tem = P_tem + real(trace(V_tem*V_tem'));
            end
            if P_tem > P
                mu_min = mu1;
            else
                mu_max = mu1;
            end
            iter = iter + 1;

            if abs(mu_max - mu_min) < 1e-5 || iter > max_iter
                break
            end
        end
        mu(k) = mu1;
    end

    for i=1:I
        for k=1:K
            V{i,k} =  inv((A{k}+mu(k)*eye(T)))*alpha1(i,k)*((H{i,k,k}')*U{i,k}*W{i,k}); % 公式15
        end 
    end 
end