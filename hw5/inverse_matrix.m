function B = inverse_matrix(A)
%INVERSE_MATRIX := finds inverse of A using LU decomposition
%   Inputs:
%       A <- invertible n x n matrix
%   Ouputs: 
%       B <- A^(-1)

[p,L,U] = lu_decomp(A); 
id=eye(size(A)); % identity matrix
P=id(:,p); % permuted identity matrix

B=-1.0*ones(size(A)); % declare/initialize B

for i=1:size(A,1)
    u_x = forwardSub(L,P(:,i));
    x=backSub(U,u_x);

    B(:,i) = x; % building B column-wise
end

B = B(:,p); % undoing permutation

end