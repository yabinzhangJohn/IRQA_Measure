% Experimental test on MIT RetargetMe dataset, 
% Code by Yabin Zhang, for the TIP paper
% Yabin Zhang, Weisi Lin, Qiaohong Li, Wentao Cheng, Xinfeng Zhang:
% Multiple-Level Feature-Based Measure for Retargeted Image Quality.
% IEEE Trans. Image Processing 27(1): 451-463 (2018)

% To run the code
% prepare the MIT RetargetMe dataset and correct the root path

clear all; clc
tic
%% path and other initial information
PATH_ROOT = '..\..\MIT dataset\'; % the path direct to the MIT dataset
% load the subjective data (put the subjData at the same path)
load([PATH_ROOT 'subjData-ref_37.mat'])
subj_data = subjData.data;
SET_NUM = 37;   % 37 set images   
PATH_NAME = cell(SET_NUM,1);
All_ratio = zeros(SET_NUM,1);
for set_num = 1:SET_NUM
    foo = subjData.datasetNames{set_num};
    foo_loc = strfind(foo,'_0.');
    PATH_NAME{set_num} =  foo(1:foo_loc-1);
    if(strfind(foo,'_0.75'))
        All_ratio(set_num) = 75;
    elseif(strfind(foo,'_0.50'))
        All_ratio(set_num) = 50;
    end
end  
OP_NUM = 8; 
operator_name = {'CR', 'SV', 'MOP', 'SC', 'SCL', 'SM', 'SNS', 'WARP'};
operator_id = {'cr', 'sv', 'multiop', 'sc.', 'scl', 'sm', 'sns', 'warp'}; 

addpath('Utilities\')
addpath('RankSVM\');
addpath('..\ARS_code\');
EDGEBOX_PATH = 'EdgeGroup\';
DT_PATH = 'DT\';

Alpha_ars = 0.7;
Beta_egs = 0.2;
C_ars = 1e-6; % to avoid the division by zero.

%% backward registration
MLF_stage1_backwardregistration

%% feature generation
MLF_stage2_feat_ars
MLF_stage2_feat_egs
MLF_stage2_feat_fbs

%% LOOCV with SVM rank
load('tmp_feat_data\MIT_ARS.mat')
load('tmp_feat_data\MIT_EGS.mat')
load('tmp_feat_data\MIT_FBS.mat')
feat_ars = MIT_ARS_score;
feat_egs = MIT_EGS_score;
feat_fbs = MIT_FBS_score;

C = 2^4.8;  gamma = 2^3.2; 
for set_num = 1:SET_NUM
    disp(['  ######## set_num = ' num2str(set_num)]);
    feat_ars_train = feat_ars(setdiff([1:37],set_num),:);
    feat_egs_train = feat_egs(setdiff([1:37],set_num),:);
    feat_fbs_train = feat_fbs(setdiff([1:37],set_num),:);
    subj_data_train = subj_data(setdiff([1:37],set_num),:);

    feat_ars_test = feat_ars(set_num,:);
    feat_egs_test = feat_egs(set_num,:);
    feat_fbs_test = feat_fbs(set_num,:);    
    subj_data_test = subj_data(set_num,:);    
    MIT_rankSVM_train_rbf(feat_ars_train, ...
        feat_egs_train, feat_fbs_train, subj_data_train, C, gamma);
    pred_score = MIT_rankSVM_test_rbf_by_score(feat_ars_test, ...
        feat_egs_test, feat_fbs_test, subj_data_test);
    obj_score(set_num, :) = pred_score;
end
KRCC_eval(subj_data, obj_score);

total_computation_time = toc;
disp(['Total computation time: ' num2str(total_computation_time, '%0.1f') 's']);













