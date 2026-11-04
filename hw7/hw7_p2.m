clear; close all;

%%
movie_tbl_original = load_ratings('MovieRankingData2026_1.csv');
movie_tbl_original

rating_labels = 0:5;
movie_names = movie_tbl_original.Properties.VariableNames(2:end);

figure('Position', [50 50 1200 1700]);
tiledlayout(8, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:numel(movie_names)
    % Round ratings to nearest integer
    rounded = round(movie_tbl_original{:, i + 1});

    % Count occurrences of each rating 0..5
    counts = sum(rounded == rating_labels, 1);

    nexttile;
    bar(rating_labels, counts);
    xticks(rating_labels);
    xlabel('Rating');
    ylabel('Count');
    title(movie_names{i}, 'Interpreter', 'none');
end

movie_tbl = load_ratings('MovieRankingData2026_1_modified.csv');
movie_tbl

A = movie_tbl{:, 2:end};
[n, m] = size(A);

% The matrix A already has 0's for the empty entries
mask = (A ~= 0);

% Projector onto the known entries
G_Omega = @(M) mask .* M;

% Omega_i: movies rated by viewer i
Omega_i = @(i) find(mask(i, :));

% Omega_j: viewers who rated movie j
Omega_j = @(j) find(mask(:, j)).';

% Test mask, Omega_i and Omega_j
i = 1;
disp(mask(i, :));
disp(Omega_i(i));

j = 1;
disp(mask(:, j).');
disp(Omega_j(j));

for i = 1:n
    fprintf('Viewer %s has %d movie ratings\n', ...
            movie_tbl.Viewer(i), numel(Omega_i(i)));
end

%% matrix completion algorithm

% Load the modified data matrix A (blank cells -> 0 = unknown)
T = readtable('MovieRankingData2026_1_modified.csv', 'VariableNamingRule', 'preserve');
A = T{:, 2:end};
A(isnan(A)) = 0;
[n, m] = size(A);
mask = (A~=0);

lambdas = [0.001 0.01 0.1 1 10];
ks = 10:15;
num_iter = 50;

Res_mat = zeros(numel(lambdas), numel(ks));
Min_mat = zeros(numel(lambdas), numel(ks));
Max_mat = zeros(numel(lambdas), numel(ks));

for a = 1:numel(lambdas)
    lambda = lambdas(a);
    for b = 1:numel(ks)
        k = ks(b);

        rng(0); X = rand(n,k);
        rng(0); Y = rand(k,m);

        res = zeros(num_iter,1);
        for t = 1:num_iter
            for i = 1:n
                Oi = find(mask(i,:));
                YO = Y(:,Oi);
                X(i,:) = ((YO*YO' + lambda*eye(k))\(YO*A(i,Oi)'))'; % x update
            end

            for j = 1:m
                Oj = find(mask(:,j));
                XO = X(Oj,:);
                Y(:,j) = (XO'*XO + lambda*eye(k))\(XO'*A(Oj,j)); % y update
            end

            % Residual ||G_Omega(A - XY)||_F^2
            res(t) = norm(mask.*(A-X*Y), 'fro')^2;
        end

        M = X*Y;
        Res_mat(a,b) = res(end);
        Min_mat(a,b) = min(M(:));
        Max_mat(a,b) = max(M(:));
    end
end

% Rows: lambda = 0.001, 0.01, 0.1, 1, 10.  Columns: k = 10, 11, ..., 15.
Res_mat
Min_mat
Max_mat


%% 2e

% HW7 Problem 2(e): run the algorithm once with lambda = 0.1, k = 15

% Load the modified data matrix A (blank cells -> 0 = unknown)
T = readtable('MovieRankingData2026_1_modified.csv', 'VariableNamingRule', 'preserve');
A = T{:, 2:end};
A(isnan(A)) = 0;
[n, m] = size(A);
mask = (A ~= 0);

lambda = 0.1;
k = 15;
num_iter = 50;

% Random initialization
rng(0); X = rand(n,k);
rng(0); Y = rand(k,m);

res = zeros(num_iter, 1);
for t = 1:num_iter
            for i = 1:n
                Oi = find(mask(i,:));
                YO = Y(:,Oi);
                X(i,:) = ((YO*YO' + lambda*eye(k))\(YO*A(i,Oi)'))'; % x update
            end

            for j = 1:m
                Oj = find(mask(:,j));
                XO = X(Oj,:);
                Y(:,j) = (XO'*XO + lambda*eye(k))\(XO'*A(Oj,j)); % y update
            end
            res(t) = norm(mask.*(A-X*Y), 'fro')^2;
        end

M = X*Y;

Mc = int32(min(max(round(M), 1), 5))

T0 = readtable('MovieRankingData2026_1.csv', 'VariableNamingRule', 'preserve');
A0 = T0{:, 2:end};  A0(isnan(A0)) = 0;
r = 3;
array2table([A0(r,:); A(r,:); double(Mc(r,:))]', ...
    'RowNames', T.Properties.VariableNames(2:end), ...
    'VariableNames', {'original', 'modified', 'M'})

%% ------------------------------------------------------------------------
% Local function (must stay at the end of the script)
function T = load_ratings(filename)
    % Read the CSV keeping the movie titles as column names, force the
    % rating columns to numbers, and replace blanks (NaN) with 0, like
    % pandas read_csv(...).fillna(0).
    opts = detectImportOptions(filename, 'VariableNamingRule', 'preserve');
    opts = setvartype(opts, opts.VariableNames(1), 'string');
    opts = setvartype(opts, opts.VariableNames(2:end), 'double');
    T = readtable(filename, opts);

    R = T{:, 2:end};
    R(isnan(R)) = 0;
    T{:, 2:end} = R;
end