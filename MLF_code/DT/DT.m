function [ dt_out] = DT(input_im )
% Distance Transform Summary of this function goes here
%   Detailed explanation goes here

    INF_C = 1E20;
    im = input_im;
    dt_map = double(0*(im));
    dt_map(im>0) = 0;
    dt_map(im ~=0 ) = INF_C;
    dt_out = DT_2D(dt_map);
end

