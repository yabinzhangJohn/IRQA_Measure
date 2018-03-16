function [ edge_org_output ] = EdgeMatchingORG(v_id_org, v_id_ret, linearInd)

    [h_org, w_org, ~] = size(v_id_org);
    
    edge_org = double(v_id_org); 
    edge_org(edge_org > 0) = 1;
    
    edge_match = double(0*edge_org);
    for edge_i = 1:max(v_id_ret(:))
        edge_set = v_id_ret == edge_i;
        edge_set_mapped = linearInd(edge_set);
        edge_mapped = zeros(h_org, w_org);
        edge_mapped(edge_set_mapped) = 1;
         edge_match =  EdgeLocation(edge_match, edge_org, edge_mapped, edge_i);
    end
    
    edge_org_output = edge_match;

end

