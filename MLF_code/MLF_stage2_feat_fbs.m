
MIT_FBS_score = ones(SET_NUM, OP_NUM);

% the face detection results using face++ API
load('Face_detection_results/MIT_face.mat') 

FACE_IM_NUM = length(MIT_face.im_name);
Face_detection_set = zeros(FACE_IM_NUM,1);
for face_im_i = 1:FACE_IM_NUM
    foo_name = MIT_face.im_name{face_im_i};
    for set_num = 1:SET_NUM
        if(strcmp(PATH_NAME{set_num}, foo_name))
            Face_detection_set(face_im_i) = set_num;
        end
    end    
end
FB_block_pos = [];
ALPHA_FACE = 0.3;
for face_im_i = 1:FACE_IM_NUM
    set_num = Face_detection_set(face_im_i);
    disp(['  - EGS #' num2str(set_num, '%02.0f') ' [' PATH_NAME{set_num} ']  image set evaluating ...']);
    im_name = MIT_face.im_name{face_im_i};
    face_block_info = MIT_face.face{face_im_i};
    face_num = MIT_face.face_num(face_im_i);

    [h, w, ~] = size(All_img_org{set_num});
    % face++ data convertion into face block data
    FB_block_pos_M = [];
    for i = 1:face_num
        face = face_block_info(i,:);
        height = face(1) *h /100;
        width = face(2) *w /100;

        yaw = face(3)*pi/180*0;
        pitch = face(4)*pi/180;
        roll = face(5)*pi/180;

        center = [face(6:7)] .*[w h] /100;
        Unit_2D = CalFaceBlock(height, width, yaw, pitch, roll, center);
        
        FB_L = min(Unit_2D(1,1), Unit_2D(3,1));
        FB_R = max(Unit_2D(2,1), Unit_2D(4,1));
        FB_T = min(Unit_2D(3,2), Unit_2D(4,2));
        FB_B = max(Unit_2D(1,2), Unit_2D(2,2));
        FB_block_pos_M(i,:) = round([FB_L FB_T FB_R FB_B]);
    end


    for set_num = Face_detection_set(face_im_i)
        
        im_org = All_img_org{set_num};
        for op_num = 1:OP_NUM      
            im_ret = All_img_ret{set_num, op_num};
            
            XX = All_XX{set_num, op_num}; YY = All_YY{set_num, op_num};
            [Func_aprox_X,   Func_aprox_Y] = ReforumlatedMapping(im_org, XX, YY);

            Face_block_ARS_M = [];
            for i = 1:face_num
                FB_block_pos = FB_block_pos_M(i,:);
                CBlock_Func_aprox_X = Func_aprox_X(FB_block_pos(2):FB_block_pos(4), ...
                    FB_block_pos(1):FB_block_pos(3));
                CBlock_Func_aprox_Y = Func_aprox_Y(FB_block_pos(2):FB_block_pos(4), ...
                    FB_block_pos(1):FB_block_pos(3));
                CSet_Ret = [CBlock_Func_aprox_X(:)...
                        CBlock_Func_aprox_Y(:)]; 
                CSet_Ret(CSet_Ret(:,1) == -1,:) = [];
                CSet_Ret(CSet_Ret(:,2) == -1,:) = [];
                X_MAX_ret = max(CSet_Ret(:,1)); X_MIN_ret = min(CSet_Ret(:,1)); 
                Y_MAX_ret = max(CSet_Ret(:,2)); Y_MIN_ret = min(CSet_Ret(:,2));

                w_ratio = (X_MAX_ret - X_MIN_ret)/(FB_block_pos(4) -FB_block_pos(2) );
                h_ratio = (Y_MAX_ret - Y_MIN_ret)/(FB_block_pos(3) -FB_block_pos(1) );
                m_ratio = (w_ratio + h_ratio)/2;

                Face_block_ARS_M(i) =  exp( -ALPHA_FACE*(m_ratio-1).^2)*...
                                        (2*w_ratio*h_ratio+C_ars)/(w_ratio^2+h_ratio^2+C_ars);
            end
            MIT_FBS_score(set_num, op_num) = mean(Face_block_ARS_M);
        end
    end

end