function U = find_U1(H,V,sigma2,R,I,K,d)
    J = cell(I,K);
    J(:)={zeros(R,R)};
    U = cell(I,K);
    U(:)={zeros(R,d)};
    for i=1:I
        for k=1:K
            for j=1:K
                for l=1:I
                    J{i,k} = J{i,k} + H{i,k,j}*V{l,j}*(V{l,j}')*(H{i,k,j}'); % 算法Table I, 第四行括号求和的部分
                end
            end
            J{i,k} = J{i,k} + sigma2*eye(R); % 算法Table I, 第四行括号求和加上噪声项的部分
            U{i,k} = J{i,k}\H{i,k,k}*V{i,k}; % 算法Table I, 第四行括号求逆，然后乘以H乘以V
        end
    end     
end