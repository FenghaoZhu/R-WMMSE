function system_rate = sum_rate1(H,V,sigma2,R,I,K,alpha1)
    rate = zeros(I,K);
    for i=1:I
        for k = 1:K
            temp = zeros(R,R);
            for l=1:I
                for j=1:K
                    if l~=i || j~=k
                        temp = temp + H{i,k,j}*V{l,j}*(V{l,j}')*(H{i,k,j}');
                    end
                end
            end
            rate(i,k) = log2(det(eye(R)+H{i,k,k}*V{i,k}*(V{i,k}')*(H{i,k,k}')*inv(temp + sigma2*eye(R)))); % 公式2
        end
    end
    system_rate = real(sum(rate.*alpha1,'all'));
end