function X = find_X(alpha1, H_hat,sigma2, U, W, T , R ,I ,d ,P )

    eta = alpha1(1,1) * trace(U(:,:,1)*W(:,:,1)*(U(:,:,1)'));
    W_hat = alpha1(1,1) * W(:,:,1);
    U_hat = U(:,:,1);
    % 计算分块矩阵，为了进一步降低复杂度
    for i = 2:I
        W_hat = blkdiag(W_hat, alpha1(i,1) * W(:,:,i));
        U_hat = blkdiag(U_hat, U(:,:,i));
        eta = eta + alpha1(i,1) * trace(U(:,:,i)*W(:,:,i)*(U(:,:,i)'));
    end

    eta = eta * sigma2 / P;
    % 计算低维度的坍塌矩阵X_hat
    X_hat = U_hat / (eta * inv(W_hat) + U_hat' * H_hat * U_hat);

    % 将低维度的坍塌矩阵X_hat由二维矩阵形式转换为三维矩阵形式以兼容代码数据格式
    X = zeros(R*I,d,I); % 每个基站的坍塌波束赋形矩阵
    for i = 1:I
        X(:,:,i) = X_hat(:, d*(i-1) + 1:d*i);
    end
    
    % % 另外一种稍慢的表达方式
    % J=zeros(I*R, I*R, I);
    % IN=zeros(I,1);
    % X=zeros(R*I,d, I);
    % for i=1:I
    % 
    %         for l=1:I
    %             J(:,:,i) = J(:,:,i) + alpha1(l, 1) * H_hat(R*(l-1)+1:R*l, :)'*U(:,:,l)*W(:,:,l)*(U(:,:,l)')*(H_hat(R*(l-1)+1:R*l, :)); % R-WMMSE公式24括号里面求信号项  
    %             IN(i) = IN(i) + alpha1(l, 1) * trace(U(:,:,l)*W(:,:,l)*(U(:,:,l)')); % R-WMMSE公式26括号里面求干扰项 
    %         end
    % 
    %         X(:,:,i) = (J(:,:,i) + IN(i) * H_hat * sigma2 / P) \ (alpha1(i, 1) * (H_hat(R*(i-1)+1:R*i, :)'*U(:,:,i)*W(:,:,i))); 
    % 
    % end     
end































