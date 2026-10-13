function x = forwardSub(L,b)
% forwardSub := this function solves Lx = b by performing forward substitution on an n x n lower triangular matrix L  
%   Inputs:
%       L <- n x n lower triangular matrix
%       b <- RHS vector
%   Ouputs: 
%       x <- solution of Lx=b

n=size(L,1);
x = zeros(n,1); % declare/initialize x
ll = diag(L); % diagonal entries of L

if min(abs(ll)) == 0 % check for 0 on diagonal
    print('Error - 0 on the diagonal.\n')
else
    x(1) = b(1)/ll(1);
    for i = 2:n        
        left_diag = L(i,1:i-1)*x(1:i-1); % sum of entries left of diagonal
        x(i) = (b(i) - left_diag)/ll(i);
    end
end

end