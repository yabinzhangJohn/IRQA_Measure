function [XX, YY] = BWRegistration(img_org, img_ret)
%   Summary of this function goes here 
%   Detailed explanation goes here

  
    % standard parameter setting for SIFTflow matching
    cellsize=3; gridspacing = 1;
    SIFTflowpara.alpha= 2*255;
    SIFTflowpara.d= 40*255;
    SIFTflowpara.gamma=0.000*255; %  remove small displacement term 
    SIFTflowpara.wsize=2;
    SIFTflowpara.topwsize=10;
    SIFTflowpara.nTopIterations = 60;
    SIFTflowpara.nIterations= 30;
    SIFTflowpara.nlevels= LevelAdaptiveSetting(img_org); % update the hierarchical levels
    SIFT_COE = 1; COLOR_COE = 100; POS_COE = 10; % standard setting

    original_im_d=im2double(img_org);
    sift_org = mexDenseSIFT(original_im_d,cellsize,gridspacing);
    % modify the feature
    colorTransform = makecform('srgb2lab');
    lab_org = applycform(original_im_d, colorTransform);
    [yy_org, xx_org] = meshgrid(1:size(original_im_d,2), 1:size(original_im_d,1));
    yy_org = yy_org/max(max(yy_org))*255;
    xx_org = xx_org/max(max(xx_org))*255;
    feature_org(:,:,1:128) = uint8(sift_org);
    feature_org(:,:,129:131) = uint8(lab_org);
    feature_org(:,:,132) = uint8(xx_org);
    feature_org(:,:,133) = uint8(yy_org);
    feature_org(:,:,134) = SIFT_COE;
    feature_org(:,:,135) = COLOR_COE;
    feature_org(:,:,136) = POS_COE;
    
    [height1,width1,~]=size(original_im_d);

    ret_im=im2double(img_ret);
    sift_ret = mexDenseSIFT(ret_im,cellsize,gridspacing);
    % modify the feature
    lab_ret = applycform(ret_im, colorTransform);
    [yy_ret, xx_ret] = meshgrid(1:size(ret_im,2), 1:size(ret_im,1));
    yy_ret = yy_ret/max(max(yy_ret))*255;
    xx_ret = xx_ret/max(max(xx_ret))*255;
    feature_ret(:,:,1:128) = uint8(sift_ret);
    feature_ret(:,:,129:131) = uint8(lab_ret);
    feature_ret(:,:,132) = uint8(xx_ret);
    feature_ret(:,:,133) = uint8(yy_ret);
    feature_ret(:,:,134) = SIFT_COE;
    feature_ret(:,:,135) = COLOR_COE;
    feature_ret(:,:,136) = POS_COE;

    [vx_BD,vy_BD,~]=SIFTflowc2f(feature_ret,feature_org,SIFTflowpara); % modified matching
    [height2,width2,~]=size(ret_im);
    [XX_ret,YY_ret]=meshgrid(1:width2,1:height2);
    XX=XX_ret+vx_BD;
    YY=YY_ret+vy_BD;
    XX=min(max(XX,1),width1);
    YY=min(max(YY,1),height1);
    
end

