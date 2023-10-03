% A test script using templeCoords.mat
%
% Write your code here
%
clear all;
close all;
a = load('../data/someCorresp.mat');
i = load('../data/intrinsics.mat');
t = load('../data/templeCoords.mat');
pts1 = a.pts1;
pts2 = a.pts2;
K1 = i.K1;
K2 = i.K2;
tempCoord_pts1 = t.pts1;
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
% M = max(size(im1,2), size(im1,1));
M = a.M;
F = eightpoint(pts1, pts2, M);
% displayEpipolarF(im1, im2, F)
% epipolarMatchGUI(im1, im2, F);
tempCoord_pts2 = epipolarCorrespondence(im1, im2, F, tempCoord_pts1);

figure;
subplot(121);
imshow(im1);
hold on;
plot(tempCoord_pts1(:, 1), tempCoord_pts1(:, 2), '*', 'MarkerSize', 3, 'LineWidth', 2);
subplot(122);
imshow(im2);
hold on;
plot(tempCoord_pts2(:, 1), tempCoord_pts2(:, 2), '*', 'MarkerSize', 3, 'LineWidth', 2);
hold off;

test_pts1 = [tempCoord_pts1, ones(size(tempCoord_pts2,1),1)];
test_pts2 = [tempCoord_pts2, ones(size(tempCoord_pts2,1),1)];
E = essentialMatrix(F, K1, K2);
P2E = camera2(E);
P1E = [eye(3), zeros(3,1)];
P1 = K1 * P1E;


count_m = 0;
pts_3d = zeros(size(tempCoord_pts1,1), 3);
P2Best = P2E(:,:,1);
P2count = 0;
for i = 1:size(P2E,3)
    P2 = K2 * P2E(:,:,i);
    pts_3d_t = zeros(size(tempCoord_pts1,1), 3);
    for j = 1:size(tempCoord_pts1, 1)
        pts_3d_t(j, :) = triangulate(P1, tempCoord_pts1(j, :), P2, tempCoord_pts2(j, :));
    end
%     pts_3d_t = triangulate(P1, tempCoord_pts1, P2, tempCoord_pts2);
    count_t = sum(pts_3d_t(:, 3) > 0);
    if (count_t > count_m)
        count_m = count_t;
        pts_3d = pts_3d_t;
        P2Best = P2;
        P2count = i;
    end
end
%'reprojection error'
some_pts_3d = zeros(size(pts1,1), 3);
for i=1:size(pts1,1)
    some_pts_3d(i,:) = triangulate(P1, pts1(i, :), P2Best, pts2(i, :));
end
some_pts_3d = [some_pts_3d, ones(size(some_pts_3d,1), 1)];
some_test_pts2 = [pts2, ones(size(pts2,1),1)];
re_pts2 = P2Best * (some_pts_3d');
re_pts2 = re_pts2';
re_pts2 = [re_pts2(:, 1)./re_pts2(:, 3), re_pts2(:, 2)./re_pts2(:, 3), ones(size(re_pts2, 1),1)];
norm(mean(re_pts2 - some_test_pts2))
figure;
%scatter3(pts_3d(:,1), pts_3d(:,2), pts_3d(:,3), 4, 'filled');
scatter3(pts_3d(:,3), pts_3d(:,2), pts_3d(:,1),20,'filled');

R1 = eye(3);
R2 = P2E(:, 1:3, P2count);
t1 = zeros(3,1);
t2 = P2E(:,4, P2count);
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');



