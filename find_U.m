function U = find_U(H_hat,X,sigma2, P, R,I,d)

    J = zeros(R,R,I);  %计算不含噪声项的矩阵
    IN = zeros(R,R,I); %计算含噪声项的矩阵
    U = zeros(R,d,I);

    for i=1:I
            for l=1:I
                    J(:,:,i) = J(:,:,i) + H_hat(R*(i-1)+1:R*i, :)*X(:,:,l)*(X(:,:,l)')*(H_hat(R*(i-1)+1:R*i, :)'); % R-WMMSE公式24括号里面求信号项  
                    IN(:,:,i) = IN(:,:,i) + sigma2 / P * trace(H_hat*X(:,:,l)*(X(:,:,l)'))* eye(R); % R-WMMSE公式24括号里面求干扰项 
            end
            U(:,:,i) = (J(:,:,i) + IN(:,:,i)) \ (H_hat(R*(i-1)+1:R*i, :)*X(:,:,i)); 
    end     
end