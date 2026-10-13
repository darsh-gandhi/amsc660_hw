function y = backSub(U,b)
% backSub := this function solves Uy = b by performing back substitution on an n x n upper triangular matrix U  
%   Inputs:
%       U <- n x n upper triangular matrix
%       b <- RHS vector
%   Ouputs: 
%       y <- solution of Uy=b

n=size(U,1);
y = zeros(n,1); % declare/initialize x
uu = diag(U); % diagonal entries of U

if min(abs(uu)) == 0 % check for 0 on diagonal
    print('Error - 0 on the diagonal.\n')
else
    y(n) = b(n)/uu(n);
    for i = n-1:-1:1
        right_diag = U(i,i+1:n)*y(i+1:n); % sum of entries left of diagonal
        y(i) = (b(i) - right_diag)/uu(i);
    end
end

end