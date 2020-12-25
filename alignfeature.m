function [wimage] = alignfeature(defaultpath,image1name,image2name)
%alignfeature  Align two images with function contained in IAT.
%   alignfeature() function align images by function in IAT. I use SURF and
%   RANSAC function to feature matching. By extracted feature, find
%   tranform between two images and apply inverse transform of this 
%   transform to second image.
%
%   defaultpath : dataset path which contain target image and reference
%   image
%   image1name : name of first image. This image is reference of alignment.
%   image2name : name of second image. This image is target frame to align.

    refimgpath = strcat(defaultpath,image1name,'.png');
    imgpath = strcat(defaultpath,image2name,'.png');
    
    original_folder_path = strcat(defaultpath,'original_error');
    align_error_folder_path = strcat(defaultpath,'align_error');
    align_image_folder_path = strcat(defaultpath,'alignimage');
    oridiffpath = strcat(original_folder_path,'\','original_',image1name,image2name,'.png');
    aligndiffpath = strcat(align_error_folder_path,'\','align_',image1name,image2name,'.png');
    alignimgpath = strcat(align_image_folder_path,'\','alignimage_',image2name,'.png');
    
    %make new folder
    if isfolder(original_folder_path) ==0
        mkdir(original_folder_path);
    end
    if isfolder(align_error_folder_path) ==0
        mkdir(align_error_folder_path);
    end
    if isfolder(align_image_folder_path)==0
        disp("i'm in alignimage")
        mkdir(align_image_folder_path);
    end
    
    ref_frame = imread(refimgpath);
    img = imread(imgpath);
    
    origindiff = ref_frame-img;
    origindiff = double(origindiff)/double(max(origindiff,[],'all'))*255;
    imwrite(uint8(origindiff), parula,oridiffpath);
    
    [d1, l1]=iat_surf(img);
    [d2, l2]=iat_surf(ref_frame);
    
    [map, matches, imgInd, tmpInd]=iat_match_features_mex(d1,d2,.7);
    X1 = l1(imgInd,1:2);
    X2 = l2(tmpInd,1:2);

    X1h = iat_homogeneous_coords (X1');
    X2h = iat_homogeneous_coords (X2');
    [inliers, ransacWarp]=iat_ransac( X2h, X1h,'affine','tol',.05, 'maxInvalidCount', 10);

    [M,N] = size(ref_frame);
    [wimage, support] = iat_inverse_warping(img, ransacWarp, 'affine', 1:N, 1:M);
    wimage = uint8(wimage(:,1:512,:));

    aligndiff = ref_frame-wimage;
    aligndiff = double(aligndiff)/double(max(aligndiff,[],'all'))*255;
    imwrite(uint8(aligndiff),parula,aligndiffpath);
    imwrite(wimage,alignimgpath);  
   
    
end

