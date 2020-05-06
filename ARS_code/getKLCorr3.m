function rs = getKLCorr3(rank1, rank2)

len1 = length(rank1);
[mt1x, idx1] = sort(rank1, 'descend'); % ±Æ§Ç
[mt2x, idx2] = sort(rank2, 'descend');
    
    % find the rank
    for k=1:length(mt2x)
        mt1x(idx1(k))=k;
        mt2x(idx2(k))=k;
    end

pass_ct = 0;
fail_ct = 0;
total_ct = 0;
for i=1:len1
    for j=i+1:len1
        if (mt1x(i)<=3 || mt1x(j)<=3) && (mt2x(i)<=3 || mt2x(j)<=3)
%         if (mt1x(i)<=3 || mt1x(j)<=3)
%         if (rank1(i)>=rank1(j) && rank2(i)>=rank2(j)) || (rank1(i)<=rank1(j) && rank2(i)<=rank2(j))
            if (mt1x(i)>=mt1x(j) && mt2x(i)>=mt2x(j)) || (mt1x(i)<=mt1x(j) && mt2x(i)<=mt2x(j))
                pass_ct = pass_ct + 1;
            else
                fail_ct = fail_ct + 1;
            end
        total_ct = total_ct + 1;
        end
    end
end

rs = (pass_ct-fail_ct) / total_ct;
% total_ct