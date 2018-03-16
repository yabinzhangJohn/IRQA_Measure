function [] = MIT_rankSVM_train_rbf(feat1, feat2, feat3, subj_data, c, gamma)
% Summary of this function goes here
%   Detailed explanation goes here
    OUTPUT_PREC = '%0.4f';
    fid = fopen('rankSVM/tmp_data/train_data_rbf.dat','wt');
    [SET_NUM, OP_NUM] = size(feat1);
    for set_num = 1:SET_NUM
        for op_num = 1:OP_NUM
            query_str = [num2str(subj_data(set_num, op_num)) ...
                ' qid:' num2str(set_num) ...
                ' 1:' num2str(feat1(set_num, op_num), OUTPUT_PREC) ...
                ' 2:' num2str(feat2(set_num, op_num), OUTPUT_PREC) ...
                ' 3:' num2str(feat3(set_num, op_num), OUTPUT_PREC)];
            fprintf(fid, '%s\n', query_str);
        end
    end
    fclose(fid);
    cmd_learn = ['rankSVM\svm_rank_learn -v 0 -c ' num2str(c) ' -t 2 ' ...
        '-g ' num2str(gamma) ...
        ' rankSVM/tmp_data/train_data_rbf.dat rankSVM/tmp_data/model_rbf'];
    system(cmd_learn);

end

