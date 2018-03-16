function [Func_aprox_X, Func_aprox_Y] = ReforumlatedMapping(im_org, XX, YY)
% Summary of this function goes here
%   Detailed explanation goes here

    [height_org, width_org,~] = size(im_org);
    [height_ret, width_ret] = size(XX);
    XXc = uint32(YY); YYc = uint32(XX);
    Func_aprox_X = -1*ones(height_org,width_org); 
    Func_aprox_Y = -1*ones(height_org,width_org);
    for ii = 1:height_ret
        for jj = 1:width_ret
            Func_aprox_X(XXc(ii,jj),YYc(ii,jj)) = ii;
            Func_aprox_Y(XXc(ii,jj),YYc(ii,jj)) = jj;
        end
    end
    
end

