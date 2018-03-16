smap_path = '../ARS_code/MIT_smap/';
disp('>>> start backward registration ...');
for set_num = 1:SET_NUM
    disp(['>>> #' num2str(set_num, '%03.0f') ' set --- ' PATH_NAME{set_num} '.']);
    % read the image set
    path = [PATH_ROOT PATH_NAME{set_num} '\'];
    file = dir([path,'*.png']);
    im_org =  imread([path file(1).name]);
    retarget_name = zeros(OP_NUM,1);
    for i = 1:OP_NUM
        for j = 1 : size(file,1)
            k1 = strfind(file(j).name, operator_id{i});
            if(All_ratio(set_num) == 75)
                k2 = strfind(file(j).name, '_0.75');
            elseif(All_ratio(set_num) == 50)
                k2 = strfind(file(j).name, '_0.50');
            end
            if( ~isempty(k1) && ~isempty(k2))
                retarget_name(i) = j;
            end
        end
    end
    for op_num = 1:OP_NUM
        im_ret_set{op_num} = imread([path file(retarget_name(op_num)).name]);
    end
    smap =  imread([smap_path PATH_NAME{set_num} '_smap.png']);
    All_img_org{set_num} = im_org;
    All_smap{set_num} = smap;
    for op_num = 1:OP_NUM
        disp(['  ---+ #' num2str(op_num, '%02.0f') ' retargeted image: ' operator_name{op_num}]);        
        im_ret = im_ret_set{op_num}; 
        [foo_XX, foo_YY] = BWRegistration(im_org, im_ret);
        All_img_ret{set_num,op_num} = im_ret;
        All_XX{set_num,op_num} = foo_XX;
        All_YY{set_num,op_num} = foo_YY;
    end
end


