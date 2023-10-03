function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
 n = size(pts1, 1);
    
    x1 = pts1(:, 1)'; % 1 * N 
    x1 = kron(x1, [1,1,1,1]); % 4 * N
    
    y1 = pts1(:, 2)';
    y1 = kron(y1, [1,1,1,1]);
    
    x2 = pts2(:, 1)';
    x2 = kron(x2, [1,1,1,1]);
    
    y2 = pts2(:, 2)';
    y2 = kron(y2, [1,1,1,1]);
    
    p11 = repmat(P1(1, :), 1, n); % 4 -> 4 * N
    p12 = repmat(P1(2, :), 1, n);
    p13 = repmat(P1(3, :), 1, n);
    
    p21 = repmat(P2(1, :), 1, n);
    p22 = repmat(P2(2, :), 1, n);
    p23 = repmat(P2(3, :), 1, n);

    A = zeros(4, 4*n);
    A(1, :) = y1 .* p13 - p12;
    A(2, :) = p11 - x1 .* p13;
    A(3, :) = y2 .* p23 - p22;
    A(4, :) = p21 - x2 .* p23;
    
    [U, S, V] = svd(A);
    pts3d = V(:, end)';
    pts3d = reshape(pts3d, [4,n])';
    pts3d = [pts3d(:, 1)./pts3d(:, 4), pts3d(:, 2)./pts3d(:, 4), pts3d(:, 3)./pts3d(:, 4)];
end