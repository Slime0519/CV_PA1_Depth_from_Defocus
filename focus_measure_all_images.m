function [imagestack] = focus_measure_all_images(datasetpath)
%focus_measure_all_images  Consist cost volume for dataset
%   focus_measure_all_images() function make cost volume for dataset.
%	To make each frame in cost volume, convolve focus meaure and imagestack
%	in dataset by using applylaplacian() function. 
%	datasetpath : Absolute path of given dataset

filepath = strcat(datasetpath,'\alignimage\alignimage_');
pre_savepath = strcat(datasetpath,'\measured_image');
if isfolder(pre_savepath)==0
    mkdir(pre_savepath)
end

imagestack = zeros(512,512,1);
for i = (1:30)
    num2 = num2str(i,'%02d');
    imgpath = strcat(filepath,num2,'.png');   
    savepath = strcat(pre_savepath,'\',num2,'.png');   
    img = imread(imgpath);
    output = uint8(applylaplacian(img));
    imwrite((output),parula,savepath);
    imagestack = cat(3,imagestack,output);
end
imagestack = imagestack(:,:,2:end);
return