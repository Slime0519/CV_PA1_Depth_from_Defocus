function [] = align_all_images(datasetpath)
%align_all_images  Align all images in given dataset
%   align_all_images(datasetpath) is align all of frames in given
%   dataset.("boxes" & "cotton")
%   align each frames by alignfeature() function.
%   parameter 'datasetpath' is absolute path of datset, like ".../Boxes"

folderpath = strcat(datasetpath,'\');
   
for i = (1:29)
    num1 = num2str(i,'%02d');
    num2 = num2str(i+1,'%02d');
    alignfeature(folderpath,num1,num2);
end

