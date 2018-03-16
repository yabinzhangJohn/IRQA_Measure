function [mKRCC, KRCC, stdKRCC] = ...
    KRCC_eval(subj_data, obj_score)

SET_NUM = size(obj_score,1);
for set_num = 1:SET_NUM
    KRCC(set_num) = getKLCorr(subj_data(set_num,:), obj_score(set_num,:));
end
mKRCC = mean(KRCC);
stdKRCC = std(KRCC);

PREC = '%0.3f';
disp('-----------------MIT Results--------------------------');
disp(['mean KRCC = ' num2str(mKRCC, PREC)]);
disp(['std KRCC = ' num2str(stdKRCC, PREC)]);
disp('------------------------------------------------------');
end

