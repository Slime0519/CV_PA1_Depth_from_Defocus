function [init_depthmap,imagestack] = gen_initial_depthmap(datapath)
%gen_initial_depthmap  Make initial depthmap 
%   gen_initial_depthmap() Make initial depth map from cost volume. Cost
%   volume obtain by focus_measure_all_images() function.
%	It return initial depthmap and cost volume("imagestack" variable)
%	datapath : absolute path of given dataset. ex) ".../boxes"

filepath = strcat(datapath,'\initial_depthmap.png');
imagestack = focus_measure_all_images(datapath);

init_depthmap = max(imagestack,[],3);
imwrite(init_depthmap,parula, filepath);

return
end

