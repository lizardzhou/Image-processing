function [B] = enhanceContrast(A,method)
%ENHANCECONTRAST
%
%Enhance the contrast of a greyscale image A by method 'contrastStretching'
%or 'histEqualization'. If the input image is a color image, it should be
%first convert into three color channels and processed separately. Returned
%is the output image matrix B.
%
%See also adapthisteq, histogram, histeq, imadjust, imcontrast, imhistmatchn.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = double(A); %change input matrix data type to double for calculation
B = zeros(size(A)); %initialize the output matrix
hist = imhist(uint8(A));
N = 255;
imgSize = size(A,1) * size(A,2);

switch method
    case 'contrastStretching'
        %look for the minimum pixel value in image A
        k_min = min(min(A));

        %look for the maximum pixel value in image A
        k_max = max(max(A));
        
        %contrast stretching
        for i = 1:size(A,1)
            for j = 1:size(A,2)
                B(i,j) = round( ((A(i,j) - k_min) / (k_max - k_min)) * N );
            end
        end  
        B = uint8(B); %convert output matrix to uint8
        
    case 'histEqualization'
        %find nonzero elements in 'hist', put the index and correesponding values in a
        %new array histNew. 
        %1st column:pixel values
        %2nd column:amount of pixels with pixel values in 1st col
        %3rd column:cumulate value of 2nd col, calculated using cumulative
        %4th column:pixel values after histogram equalization
        histNew = [(0:255)',hist];
        histNew(:,3) = cumsum(hist);
        histNew(:,4) = round( histNew(:,3) * N / imgSize ); %histogram equalization
        
        %replace the pixel value in original image with those in new image.
        for i = 1:size(B,1)
            for j = 1:size(B,2)
                B(i,j) = histNew( histNew( A(i,j),1 ),4 );
            end
        end        
        B = uint8(B); %convert output matrix to uint8

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%by Xiye Zhou
