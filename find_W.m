function W = find_W(U,H_hat,X, R, I,d)
    W = zeros(d,d,I);
    for i=1:I
            W(:,:,i) = inv(eye(d)-U(:,:,i)'*H_hat(R*(i-1)+1:R*i, :)*X(:,:,i)); 
    end
end