function [img] = gen_initial_all_focus(disparity_stack,Datapath)
%gen_initial_all_focus  Make initial all-in-focus image
%   gen_initial_all_focus() make initial all-in-focus image
%	from cost volume(initial depth map). To get frame's index
%	and pixel value, I use max() in MATLAB.

	folderpath = strcat(Datapath,'\alignimage\alignimage_')
	imagestack = zeros(30,512,512,3);
	for i=1:30
	   filepath = strcat(folderpath, num2str(i,'%02d'),'.png');
	   imagestack(i,:,:,:) = imread(filepath);
	end
	img = zeros(512,512,3);

	[init_depthmap,max_index] = max(disparity_stack,[],3);
	disp(size(max_index));
	for i = 1:512
		for j = 1:512
			img(i,j,:) = imagestack(max_index(i,j),i,j,:);
		end
	end

	img= uint8(img)
	return
end