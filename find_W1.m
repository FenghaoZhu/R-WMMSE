function W = find_W1(U,H,V,I,K,d)
    W = cell(I,K);
    W(:) = {zeros(d,d)};
    for i=1:I
        for k=1:K
            W{i,k} = inv(eye(d)-U{i,k}'*H{i,k,k}*V{i,k}); % 算法Table I, 第五行
        end
    end
end