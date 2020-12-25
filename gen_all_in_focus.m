function [img] = gen_all_in_focus(depthmap,Datapath)
%gen_all_in_focus  Make all-in-focus image from refined depth map
%   This function make all-in-focus image from refined depth map.
%   To make all-in-focus image, it require refined depthmap and absolute
%   dataset path.

folderpath = strcat(Datapath,'\');
imagestack = zeros(30,512,512,3);
for i=1:30
   filepath = strcat(folderpath, num2str(i,'%02d'),'.png');
   imagestack(i,:,:,:) = imread(filepath);
end

img = zeros(512,512,3);

for y = 1:512
    for x = 1:512
        index = depthmap(y,x);
        img(y,x,:) = imagestack(index,y,x,:);        
    end
end
img= uint8(img)
return
end