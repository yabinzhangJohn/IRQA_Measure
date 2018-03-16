function rs = getKLCorr(sc1, sc2)
% Kendall tau rank correlation coefficient
[mt1x, idx1] = sort(sc1, 'descend'); 
[mt2x, idx2] = sort(sc2, 'descend');

% find the rank
for k=1:length(sc1)
    mt1x(idx1(k))=k;
    mt2x(idx2(k))=k;
end
rank1 = mt1x;
rank2 = mt2x;

len1 = length(rank1);

pass_ct = 0;
fail_ct = 0;
total_ct = 0;
for i=1:len1
    for j=i+1:len1
        if (rank1(i)>=rank1(j) && rank2(i)>=rank2(j)) || (rank1(i)<=rank1(j) && rank2(i)<=rank2(j))
            pass_ct = pass_ct + 1;
        else 
            fail_ct = fail_ct + 1;
        end
        total_ct = total_ct + 1;
    end
end

rs = (pass_ct-fail_ct) / total_ct;