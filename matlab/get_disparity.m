function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

    [iw, ih] = size(im1);
    d = zeros(iw, ih, maxDisp+1);
    w = (windowSize - 1)/2;
    im1 = im2double(im1);
    im2 = im2double(im2);
    imd1 = padarray(im1, [w, w], 'replicate', 'both');
    imd2 = padarray(im2, [w, w], 'replicate', 'both');
    
    for i = 0:maxDisp
        for q = 1:iw
            for p = 1:ih
                temp = imd1(q:q+2*w, p:p+2*w) - imd2(max(1,q-i):max(1, q-i)+2*w, p:p+2*w);
                temp = temp.^2;
                res = conv2(temp, ones(size(temp)), 'valid');
                d(q,p,i+1) = res;
            end
        end
    end
    [~, dispM] = min(d, [], 3);
end