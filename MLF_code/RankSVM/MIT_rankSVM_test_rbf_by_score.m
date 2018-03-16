function [prediction_score] ...
    = MIT_rankSVM_test_rbf_by_score(feat1, feat2, feat3, subj_data)
% Summary of this function goes here
%   Detailed explanation goes here
    OUTPUT_PREC = '%0.4f';
    fid = fopen('RankSVM/tmp_test_data_rbf.dat','wt');
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
    
    cmd_test = ['RankSVM\svm_rank_classify  -v 0 ' ...
        ' RankSVM/tmp_test_data_rbf.dat' ...
        ' RankSVM/tmp_model_rbf RankSVM/tmp_prediction_rbf'];
    system(cmd_test);
    
    fileID = fopen('RankSVM/tmp_prediction_rbf','r');
    prediction_score_tmp = fscanf(fileID,'%f');
    fclose(fileID);
    
    prediction_score = reshape(prediction_score_tmp, [OP_NUM SET_NUM]);
    prediction_score = prediction_score';
end

