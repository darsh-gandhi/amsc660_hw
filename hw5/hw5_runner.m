clear; close all;

%%

A=[0.0 2.0 3.0; 4.0 5.0 6.0; 3.0 6.0 9.0];
b=[1.0; 3.0; 2.0];

%% part a

[p,L,U] = lu_decomp(A);
ux = forward_sub(L,b(p));
x = back_sub(U,ux)

%% part b

A_inv = inverse_matrix(A)