function [ edge_match ] = EdgeLocation(edge_match_input, edge_org, edge_mapped, edge_id)


N = 5;
edge_likely_region = edge_mapped;
Edge_pixel_NUM = sum(edge_mapped(:));

d_kernel = ones(N, N); 
edge_likely_region = conv2(edge_likely_region, d_kernel, 'same');
edge_likely_region(edge_likely_region > 0) = 1;

edge_found = edge_org.*edge_likely_region;
edge_match = edge_match_input;
edge_match (edge_found == 1) =  edge_id;

end

