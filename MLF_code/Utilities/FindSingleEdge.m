function [edge, edge_cen, edge_selfdiff] = FindSingleEdge(v_map, edge_ID)
% Summary of this function goes here
%   Detailed explanation goes here

    [edge_i_loc_r, edge_i_loc_c] = find(v_map == edge_ID);
    edge_i_loc_m_r = floor(mean(edge_i_loc_r));
    edge_i_loc_m_c = floor(mean(edge_i_loc_c));
    edge = [edge_i_loc_r edge_i_loc_c];
    edge_cen = [edge_i_loc_m_r, edge_i_loc_m_c];
    edge_selfdiff = edge - repmat(edge_cen, [size(edge,1), 1]);
    
end

