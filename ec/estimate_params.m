function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
   P1 = [0,0,1; 0,1,0; 1,0,0];
    A = P1 * P(:,1:3);
    c = -inv(P(:,1:3)) * P(:,4);
    [Q1, R1] = qr(A');
    R = P1*(Q1');
    K = P1*(R1')*P1;
    t = -R * c;
end
