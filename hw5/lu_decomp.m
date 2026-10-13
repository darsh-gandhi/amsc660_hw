function [p, L, U] = lu_decomp(A)
%LU_DECOMP := perfroms LU decomp with pivoting
%   Inputs:
%       A <- n x n matrix
%   Ouputs: 
%       p <- permutation "matrix" (saved as a vector)
%       L <- n x n lower triangular matrix
%       U <- n x n upper triangular matrix

n = size(A, 1);
p = 1:n;
L = eye(n);
U = A;

for i = 1:n-1
    [~, index] = max(abs(U(i:end, i)));
    ip = i + index - 1;
    
    if U(ip, i) == 0
        error('Zero pivot encountered at row %d. Matrix is singular or decomposition failed.', i);
    end
    
    if ip ~= i
        U([i, ip], :) = U([ip, i], :);
        p([i, ip]) = p([ip, i]);
        if i > 1
            L([i, ip], 1:i-1) = L([ip, i], 1:i-1);
        end
    end

    for j = i+1:n
        L(j, i) = U(j, i) / U(i, i);
        U(j, (i+1):end) = U(j, (i+1):end) - L(j, i) * U(i, (i+1):end);
        
        U(j, i) = 0;
    end
end

U = triu(U);

end