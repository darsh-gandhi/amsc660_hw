% dg 9/27/26; 16:41

clear; close all;

%% initialization

MNIST_data = load ('mnist_matlab.mat ');
MNIST_data.imgs_train;  % 20 x20x60000 training images
MNIST_data.labels_train;% 60000 x1 training image labels
MNIST_data.imgs_test;   % 20 x20x10000 test images
MNIST_data.labels_test; % 10000 x1 test image labels

%% pre-processing

[x,y,z] = size(MNIST_data.imgs_test); % x*y size of each image, z # of images

flat_data = -1.0*ones(x*y,z); % holds the flattens images
for i=1:z
    flat_data(:,i) = reshape(MNIST_data.imgs_test(:,:,i),[x*y,1]); %flattens each image into a col of flat_data
end

flat_data = flat_data';

%%

[U,S,V] = svd(flat_data);

projected = flat_data*V(:,1:2);

%%
labels = MNIST_data.labels_test;
idx0 = (labels == "0");
idx1 = (labels == "1");

p0 = projected(idx0, :);
p1 = projected(idx1, :);

figure;
scatter(p0(:, 1), p0(:, 2), 36, 'blue', 'filled');
hold on;
scatter(p1(:, 1), p1(:, 2), 36, 'red', 'filled');
xlabel('v_1'); ylabel('v_2');
title('2D Projection');
legend('0','1','Location', 'best');
grid on;
hold off;
set(gca,'FontSize',14)

%% part b

k=[10 20 50];

figure('Position',[100 100 900 950])
sgtitle('Handwritten Digits and Reconstructions')
imCount = 1;
for i=1:4
    subplot(4,4,imCount)
    imshow(MNIST_data.imgs_test(:,:,i))
    imCount=imCount+1;
end

for j=1:3
    [Uk,Sk,Vk] = svds(flat_data,k(j));
    Ak = Uk*Sk*Vk';
    for i=1:4
        recon_imgs = reshape(Ak(i,:),[20 20 1]);
        subplot(4,4,imCount)
        imshow(recon_imgs)
        imCount=imCount+1;
    end
end