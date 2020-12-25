function [output] = applylaplacian(image)
%applylaplacian  Apply focus measure to intensity map
%   To find well-focused region in image, this function
%	convert color image to intensity map(grayscale image)
%	and apply focuse measure to this image. In PA1, I
%	choose laplacian kernel to measure focus.
%	image : color image which you want to measure focus

grayimage = rgb2gray(image);
laplacian = zeros(3,3);
laplacian(2,2) = 4;
laplacian(1,2) = -1;
laplacian(2,1) = -1;
laplacian(2,3) = -1;
laplacian(3,2) = -1;
output = conv2(double(grayimage), laplacian, 'same');

return 
end

