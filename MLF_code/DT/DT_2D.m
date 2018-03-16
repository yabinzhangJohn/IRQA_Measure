function  [im] = DT_2D(im_input) 
% /* dt of 2d function using squared distance */
    im = im_input;
    [H, W] = size(im);
    
    % transform along columns
    for w = 1:W
        Col = im(:,w);
        Col_dt = DT_1D(Col, H) ;
        im(:,w) = Col_dt;
    end
    
    % transform along rows
    for h = 1:H
        Row = im(h,:);
        Row_dt = DT_1D(Row, W);
        im(h,:) = Row_dt;
    end

end
