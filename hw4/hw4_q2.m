%dg 9/27 2:49 am

clear; close all;

%%

A= @(c) [1, 1+c; 1-c, 1]; 
b=[1 2]';
b_hat = [1.001 2.001]';

c = [1e0 1e-1 1e-2 1e-3 1e-4 1e-5 1e-6];
err = -1.0*ones(size(c));
kappa = -1.0*ones(size(c));
scalar = -1.0*ones(size(c));
diff = -1.0*ones(size(c));

for i=1:length(c)
    A_i = A(c(i));
    x_i = A_i\b;
    xhat_i = A_i\b_hat;

    err(i) = norm(x_i - xhat_i,Inf);
    kappa(i) = ((2 + abs(c(i)))/c(i))^2;
    scalar(i) = (norm(b-b_hat,Inf)/norm(b,Inf))*kappa(i);
    diff(i) = scalar(i) - err(i)/norm(x_i,Inf);
end
diff>=0

%%

figure
loglog(c,err,'-o','LineWidth',2.0)
title('Error Plot')
xlabel('c'); ylabel('$\|x-\hat{x}\|_\infty$',Interpreter='latex')
ylim([1e-3 1e14])
grid  on
set(gca,'FontSize',14)

figure
loglog(c,kappa,'-o','LineWidth',2.0)
title('Condition Number')
xlabel('c'); ylabel('$\kappa(A)$',Interpreter='latex')
ylim([1e-3 1e14])
grid  on
set(gca,'FontSize',14)

figure
subplot(1,2,1)
loglog(c,err,'-o','LineWidth',2.0)
title('Error Plot')
xlabel('c'); ylabel('$\|x-\hat{x}\|_\infty$',Interpreter='latex')
ylim([1e-3 1e14])
grid on
set(gca,'FontSize',14)

subplot(1,2,2)
loglog(c,kappa,'-o','LineWidth',2.0)
title('Condition Number')
xlabel('c'); ylabel('$\kappa(A)$',Interpreter='latex')
ylim([1e-3 1e14])
grid  on
set(gca,'FontSize',14)