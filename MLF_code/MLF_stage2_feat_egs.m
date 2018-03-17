% edge group similarity
% dependence
addpath([EDGEBOX_PATH]);
addpath(DT_PATH);
addpath(genpath([EDGEBOX_PATH 'toolbox']));

% load pre-trained edge detection model and set opts
model=load([EDGEBOX_PATH 'models\forest\modelBsds']);
model=model.model; model.opts.multiscale=0;
model.opts.sharpen=2; model.opts.nThreads=4;
% set up opts for edgeGroup
opts = edgeGroup;
opts.alpha = .65;
opts.beta  = .75;
opts.minScore = .01;
opts.maxBoxes = 1e4;
opts.edgeMergeThr = 0.5;
opts.edgeMinMag = 0.1;
opts.clusterMinMag = 2;

PAD_SIZE = 20;

for set_num = 1:SET_NUM
    disp(['  - EGS #' num2str(set_num, '%02.0f') ...
        ' [' PATH_NAME{set_num} ']  image set evaluating ...']);

    im_org =  All_img_org{set_num};
    XX_set = All_XX(set_num, :); YY_set= All_YY(set_num, :);

    [h_org, w_org, ~] = size(im_org);
    [h_ret, w_ret, ~] = size(All_img_ret{set_num, 1});
    [~, v_org, v_id_org, e_org, o_org] = edgeGroup(im_org,model,opts);

    for op_num = 1:OP_NUM
        im_ret = All_img_ret{set_num, op_num};
        [~, v_ret, v_id_ret, e_ret, o_ret] = edgeGroup(im_ret,model,opts);
        rowSub = YY_set{op_num}; colSub = XX_set{op_num};
        linearInd = sub2ind([h_org, w_org], rowSub, colSub);
        edge_org_matched = EdgeMatchingORG(v_id_org, v_id_ret, linearInd);
        EDGE_NUM = max(v_id_ret(:));
        Edge_INFO = zeros(EDGE_NUM, 2); % record the edge similarity information
        for edge_i = 1:EDGE_NUM
            [edge_ret, edge_cen_ret, edge_selfdiff_ret] = FindSingleEdge(v_id_ret, edge_i);
            [edge_org, edge_cen_org, edge_selfdiff_org] = FindSingleEdge(edge_org_matched, edge_i);
            Edge_size = size(edge_selfdiff_org,1);
            Edge_INFO(edge_i,2) = Edge_size;
            if(Edge_size < 10)
                Edge_INFO(edge_i,1) = 0;
            else
                EhR_max = max(abs([edge_selfdiff_org(:,1); edge_selfdiff_ret(:,1)]));
                EwR_max = max(abs([edge_selfdiff_org(:,2); edge_selfdiff_ret(:,2)]));
                Edge_im_ret_h = EhR_max*2+1+2*PAD_SIZE;
                Edge_im_ret_w = EwR_max*2+1+2*PAD_SIZE;
                Edge_im_ret = uint8(255*ones(Edge_im_ret_h,Edge_im_ret_w));
                edge_ret_tb = edge_selfdiff_ret;
                edge_ret_tb(:,1) = edge_ret_tb(:,1) + EhR_max+1+PAD_SIZE;
                edge_ret_tb(:,2) = edge_ret_tb(:,2) + EwR_max+1+PAD_SIZE;
                edge_ret_linear = sub2ind...
                    ([EhR_max*2+1+2*PAD_SIZE, EwR_max*2+1+2*PAD_SIZE],...
                    edge_ret_tb(:,1),  edge_ret_tb(:,2));
                Edge_im_ret(edge_ret_linear) = 0;

                dt_edge_ret = DT(Edge_im_ret);
                dt_edge_ret = dt_edge_ret.^0.5;
                CM_Dist = zeros(2*PAD_SIZE+1, 2*PAD_SIZE+1);

                query_edge = edge_selfdiff_org;
                query_edge(:,1) = query_edge(:,1) + EhR_max+1;
                query_edge(:,2) = query_edge(:,2) + EwR_max+1;
                query_edge_linear_S = sub2ind...
                            ([Edge_im_ret_h, Edge_im_ret_w],...
                            query_edge(:,1),  query_edge(:,2));
                for j = -PAD_SIZE:PAD_SIZE
                    query_edge_linear = query_edge_linear_S ...
                        + (j+PAD_SIZE)*Edge_im_ret_h;
                    for i = -PAD_SIZE:PAD_SIZE
                        dist_arry = dt_edge_ret(query_edge_linear);
                        CM_Dist(i+PAD_SIZE+1, j+PAD_SIZE+1) = sum(sum(dist_arry));
                        query_edge_linear = query_edge_linear + 1;
                    end
                end

                CM_Dist = CM_Dist/Edge_size;
                CM_min = min(CM_Dist(:));
                Edge_INFO(edge_i,1) = CM_min;
            end
        end
        All_edge_info{set_num, op_num} =  Edge_INFO;
    end
end

for set_num = 1:SET_NUM
    for op_num = 1:OP_NUM
        edge_info = All_edge_info{set_num, op_num};
        edge_size = edge_info(:,2);
        edge_info(edge_size<10, :) = [];
        avg_cmd = mean(edge_info(:,1));
        All_avg_cmd(set_num, op_num) = avg_cmd;
    end
end
MIT_EGS_score = exp(-Beta_egs * All_avg_cmd.^0.5);
