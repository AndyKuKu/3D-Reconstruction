clear all;
close all;
load('../data/PnP.mat', 'X', 'x', 'cad', 'image')
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);
X_test = [X; ones(1, size(X,2))];
xe = P*X_test;
xe = ([xe(1,:)./xe(3,:); xe(2,:)./xe(3,:)])';
x = x';
figure;
imshow(image);
hold on
scatter(xe(:,1), xe(:,2), 15, 'black', '*');
scatter(x(:,1), x(:,2), 70, 'green', 'o');
hold off

v = (R * (cad.vertices'))';
figure;
trimesh(cad.faces, v(:,1), v(:,2), v(:,3));
E = [R,t];
P_l = K*E;
v_e = [cad.vertices, ones(size(v,1),1)]';
v_p = P_l * v_e;
v_p = int16(([v_p(1, :)./v_p(3, :); v_p(2, :)./v_p(3, :)])');
figure;
hold on
imshow(image);
p = patch('Faces',cad.faces,'Vertices',v_p,'FaceColor','red', 'EdgeColor','none');
p.FaceAlpha = 0.175;
hold off
