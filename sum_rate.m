function system_rate = sum_rate(H,V,sigma2,R,I,alpha1)
    rate = zeros(I,1);
    for i=1:I
            denominator = zeros(R,R);
            for l=1:I
                denominator = denominator + H(:,:,i)*V(:,:,l)*V(:,:,l)'*H(:,:,i)';
            end
            numerator = H(:,:,i)*V(:,:,i)*V(:,:,i)'*H(:,:,i)';
            denominator = denominator - numerator + sigma2*eye(R);

            rate(i) = log2(det(eye(R)+numerator / denominator));
    end
    system_rate = real(sum(rate.*alpha1,'all'));
end