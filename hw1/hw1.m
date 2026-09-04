clear; close;
colors = 1/255 * [56 182 255; 255 222 89; 0 191 99];

%%

delta = 10.^(-(1:16));
x=1;

outs = -1.0*ones(numel(delta),2);
for i=1:numel(delta)
    [outs(i,1), outs(i,2)] = funcs(x,delta(i));
end

%high precision section for reference (assumed exact value)
digits(50)
hp_x = vpa(1);
hp_delta = vpa(10.^(-(1:16)));

hp_outs = vpa(-1.0*ones(numel(delta),2));
for i=1:numel(delta)
    [hp_outs(i,1), hp_outs(i,2)] = funcs(hp_x,hp_delta(i));
end

errors = vpa(-1.0*ones(numel(delta),2));

for i=1:numel(delta)
    errors(i,1) = relErr(hp_outs(i,1),outs(i,1));
    errors(i,2) = relErr(hp_outs(i,2),outs(i,2));
end

disp('Relative errors for f1 vs f2:')
disp(double([errors(:,1), errors(:,2)]))

%%

loglog(delta, double(errors(:,1)),'-o','Color',colors(1,:))
hold on
loglog(delta, double(errors(:,2)),'ro-')
yline(eps, '--k', 'Interpreter', 'latex', 'LabelHorizontalAlignment', 'left')
title('Relative errors')
legend({'$f_1$','$f_2$','$\epsilon_M$'},'Interpreter','latex')
xlabel('$\delta$','Interpreter','latex')
ylabel('$RE(f_i,\hat{f_i})$','Interpreter','latex')
xlim([5E-17 5E-1])
set(gca,'FontSize',14)

%%

function [f1, f2] = funcs(x,delta)
    f1 = sqrt(x+delta) - sqrt(x);
    f2 = delta/(sqrt(x+delta) + sqrt(x));
end

function err = relErr(y,y_hat)
    err = abs(y-y_hat)/abs(y);
end