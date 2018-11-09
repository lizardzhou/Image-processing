function [p,Ap] = padImg(A)
%PADIMG
%
%An image matrix A is given. This function calculates the padding width p
%which allows the rotation of A in any angle without size exceeding and
%losing pixel values. Additionally, the padded image matrix Ap is calculated
%based on the p-value. Returns p and Ap.
%
%See also padarray.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A = imread('alfred_gr.png'); %load image

[rows,cols] = size(A);
%the padding width is based on the length of image diagonal, which must be 
%rounded up by 1 to assure an integer and keep all pixels in the padded image range
diagonal = ceil(sqrt(rows^2 + cols^2)); 
paddingSize = (diagonal - min(cols,rows)); 

p = ceil(paddingSize / 2); %padding width, which must be rounded up by 1 to assure an integer and keep all pixels in the padded iamge range

padTopBottom = [zeros(p,cols); A; zeros(p,cols)]; %add zero padding to the top and bottom
Ap = [zeros(rows+2*p,p),padTopBottom,zeros(rows+2*p,p)]; %add zero padding to the left and right, then the padding is completed

%figure, imshow(Ap) %show image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%by Xiye Zhou
