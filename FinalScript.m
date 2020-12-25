%script for executing whole process of PA1
%You can specify Dataset name by changing "Dataset_name" variable.
%Dataset_name can have value "cotton" or "boxes"

Dataset_name = "cotton";
Root_path = pwd;
Dataset_path = strcat(Root_path,"\PA1_dataset\",Dataset_name);
IAT_path = strcat(Root_path,"\IAT_v0.9.3");
GCO_path = strcat(Root_path,"\gco-v3.0\matlab");
WMF_path = strcat(Root_path,"\matlab_wmf_release_v1");

%%setup IAT toolbox
cd(IAT_path);
iat_setup;
mex -setup;
cd(Root_path);

%%align all images
align_all_images(Dataset_path);
im1 = imread(strcat(Dataset_path,"\01.png"));
imwrite(im1,strcat(Dataset_path,"\alignimage\alignimage_01.png"));

%%get disparity map about all images
[initialdepthmap,disparity_stack] = gen_initial_depthmap(Dataset_path);
%imagestack = permute(imagestack,[3,1,2]);
%imwrite(uint8(initialdepthmap),parula,strcat(Dataset_path,"\initial_depth_map.png"));

%%make all-in-focus image from initial depth map
init_all_focus = gen_initial_all_focus(disparity_stack,Dataset_path);
imwrite(init_all_focus, strcat(Dataset_path,"\init_all_focus_",Dataset_name,".png"));


%%apply Graph-Cut algorithm
cd(GCO_path);
GC_result_array = apply_graphcut(Dataset_path);
cd(Root_path);

GC_result = reshape(GC_result_array,[512,512]);
figure();
imagesc(GC_result)

GC_forsave = 31-GC_result;
GC_forsave = GC_forsave*255.0/30.0;
imwrite(uint8(GC_forsave),strcat(Dataset_path,"\GC_result_depthmap.png"));

%%weighted median filter
cd(WMF_path);
WMF_result = make_refined_depth(GC_result,init_all_focus);
cd(Root_path);

figure();
imagesc(WMF_result)

WMF_forsave = 31-WMF_result;
WMF_forsave = WMF_forsave*255.0/30.0;
imwrite(uint8(WMF_forsave),strcat(Dataset_path,"\WMF_refined_depthmap.png"));

% make all-in-focus image  from refined depth map
refined_all_focus = gen_all_in_focus(WMF_result,Dataset_path);
imwrite(refined_all_focus,strcat(Dataset_path,"\Final_all_in_focus.png"));


