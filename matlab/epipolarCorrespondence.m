function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

 im1 = im2double(im1); 
 im2 = im2double(im2); 
 
 epts1 = [pts1, ones(size(pts1, 1), 1)];
 l = F * epts1';
 pts1 = int16(pts1);
 rs = size(im1, 1);
 cs = size(im1, 2);
 w = 9;
 bb = 35;
 hw = floor(w/2);
 im1 = padarray(im1, [hw, hw], 'replicate', 'both'); % M+w * N+w * 3
 im2 = padarray(im2, [hw, hw], 'replicate', 'both'); 
 pts2 = zeros(size(pts1));
 for i = 1:size(l,2)
    line_p = l(:, i);
    a = line_p(1);
    b = line_p(2);
    c = line_p(3);
    c_step = double(max(1, pts1(i, 1)-bb):min(cs, pts1(i,1) + bb));
    r_step = -(a * c_step + c)/b;
    ind = find(r_step >= 1 & r_step <= rs);
    c_step = c_step(ind);
    r_step = r_step(ind);
    template = im1(pts1(i, 2):pts1(i, 2)+w, pts1(i, 1):pts1(i, 1)+w, :);
    
    step_min = 10000;
    best_ind = 0;
    c_step = int16(c_step);
    r_step = int16(r_step);
    for j = 1:size(r_step,2)-1
        yt = c_step(j);
        xt = r_step(j);
        m = im2(xt:xt+w, yt:yt+w, :);
        dist = sum(sum(sum((template-m).^2)));
        if (dist < step_min)
            step_min = dist;
            best_ind = j;
        end
    end
    pts2(i,:) = [c_step(best_ind), r_step(best_ind)];    
 end
end