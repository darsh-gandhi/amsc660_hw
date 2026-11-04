% HW7 Problem 3: level sets ||A||_* = 1 and det A = 0 for A = [0.5 x; y z]
a = 1;
zs = -0.4:0.1:0.4;
L = 1.2;
[x, y] = meshgrid(linspace(-L, L, 251));

figure('WindowState', 'maximized');
tiledlayout(3, 3, 'TileSpacing', 'tight', 'Padding', 'tight');

for p = 1:numel(zs)
    z = zs(p);

    % Nuclear norm at every grid point
    N = zeros(size(x));
    for r = 1:numel(x)
        N(r) = sum(svd([0.5 x(r); y(r) z]));
    end

    % Determinant
    D = 0.5*z - x.*y;

    nexttile; hold on;
    contour(x, y, D, [0 0], 'r--', 'LineWidth', 1.5);   % Curve 1: det A = 0
    contour(x, y, N, [a a], 'b', 'LineWidth', 1.5);     % Curve 2: ||A||_* = 1
    xlim([-L L]); ylim([-L L]);
    axis square; grid on; box on;
    title(sprintf('z = %.1f', z));
    xlabel('x'); ylabel('y');
end

exportgraphics(gcf, 'problem3.png', 'Resolution', 200);