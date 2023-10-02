function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
x1 = [X; ones(1, size(X,2))]'; % N, 4
x2 = [x; ones(1, size(x,2))]'; % N, 3

x1_pz = [x1, zeros(size(x1,1),4)];

x1_r = repelem(x1_pz, 2, 1);
x1_r(2:2:end,5:8) = x1_r(2:2:end,1:4);
x1_r(2:2:end,1:4) = 0;

x2_r = repelem(x2, 2, 1);
x2_r(1:2:end,1:4) = [x2_r(2:2:end,1), x2_r(2:2:end,1), x2_r(2:2:end,1), x2_r(2:2:end,1)];
x2_r(2:2:end,1:4) = [x2_r(2:2:end,2), x2_r(2:2:end,2), x2_r(2:2:end,2), x2_r(2:2:end,2)];
temp_x1 = repelem(x1, 2, 1);
x2_r = x2_r .* temp_x1;

A = [-x1_r, x2_r];
[~, S, V] = svd(A);
P = reshape(V(:, end), [4,3])';
end