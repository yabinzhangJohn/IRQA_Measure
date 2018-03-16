function [ levels ] = LevelAdaptiveSetting(img_org)
% Summary of this function goes here
%   Detailed explanation goes here
    [h_org, w_org] = size(img_org);
    if(h_org < w_org)
        levels =  ceil(log2(w_org/10));
    else
        levels =  ceil(log2(h_org/10));
    end

end

