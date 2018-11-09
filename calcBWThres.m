function [B,t] = calcBWThres(A,method,v)
%CALCBWTHRESH  
%
%convert a grayscale image A into binary image by thresholding using
%methods 'manual','median', 'isodata' or 'otsu'. The threshold value v is
%needed in case of manual thresholding.
%
%See also graythresh, imbinarize, otsuthresh, adaptthresh.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determine if the input image is greyscale or colored. In case of color
%image, it will be converted into greyscale using 'luma' method.
if size(A,3) == 3
    AGrey = 0.2126 .* A(:,:,1) + 0.7152 .* A(:,:,2) + 0.0722 .* A(:,:,3); 
else
    AGrey = A;
end   

imgSize = size(AGrey,1) * size(AGrey,2);

switch method
    %set the input value v as threshold t
    case 'manual' 
        if v > 0 && v <= 255
            AGrey(AGrey <= v) = 0;
            AGrey(AGrey > v) = 255;
            B = AGrey;
            t = v;
        else
            if v <= 0
                B = zeros(size(AGrey));
            else
                B = 255 * ones(size(AGrey));
            end
        end  
        
    %calculate the threshold t producing the same amount of black and white pixels          
    case 'median' 
        imgSize = size(AGrey,1) * size(AGrey,2); %counting the sum of H_u(k)
        hist = [(0:255)',imhist(AGrey)]; 
        cumSum = cumsum(hist(:,2)); %calculate the cumulative sum of H_u(k) for every k
        %summary of histogram data: 
        %1st col:k-values, 2nd col:H_u(k), 3rd col:cumulative sum of H_u(k)
        hist = [hist,cumSum];
        
        t = 0; %initialize the threshold
        for i = 1:size(hist,1)
            t = t + 1;
            if hist(i,3) > imgSize / 2 % if the cumulative sum of the i-value exceeds the half, threshold t is reached
                break
            end
        end    
        B = AGrey;        
        B(B <= t) = 0;
        B(B > t) = 255;
    
    %calculate threshold t using isodata method    
    case 'isodata'
        %summary of histogram data in array "hist":
        %1st column:pixel value k from 0 to 255
        %2nd column:H_u(k)
        %3rd column:cumulative sum of H_u(k)
        %4th column:k*H_u(k)
        %5th column:cumulative sum of k*H_u(k)
        hist = [(0:255)',imhist(AGrey)];
        hist(:,3) = cumsum(hist(:,2));
        hist(:,4) = hist(:,1) .* hist(:,2);
        hist(:,5) = cumsum(hist(:,4));

        %build function for fixed point iteration. The function value must
        %be an integer (pixel value)
        fun = @(t) round((hist(t,5) / hist(t,3) + ( hist(256,5) - hist(t,5) ) / ( imgSize - hist(t,3) )) / 2);
        
        %calculate the threshold t using fixed point iteration
        t = fixedPoint(find(hist(:,3) > 0,1),0.001,fun); %find the first pixel value i with H_u(i) != 0 to avoid division by zero
        
        B = AGrey;        
        B(B <= t) = 0;
        B(B > t) = 255;
    
    %calculate threshold t using Otsu's method    
    case 'otsu'
        %summary of histogram data in array "hist":
        %1st column:pixel value k from 0 to 255     %5th column:cumulative sum of k*H_u(k)
        %2nd column:H_u(k)                          %6th column:probablility that a randomly chosen pixel is black
        %3rd column:cumulative sum of H_u(k)        %7th column:inter-class variance at k
        %4th column:k*H_u(k)
        hist = [(0:255)',imhist(AGrey)];
        hist(:,3) = cumsum(hist(:,2));
        hist(:,4) = hist(:,1) .* hist(:,2);
        hist(:,5) = cumsum(hist(:,4));
        hist(:,6) = hist(:,3) / imgSize;
        hist(:,7) = hist(:,6) .* ( 1 - hist(:,6) ) .* ...
                   ( hist(:,5) ./ hist(:,3) - ( hist(256,5)-hist(:,5) ) ./ ( imgSize-hist(:,3) ) ).^2;
        
        sigmaMax = max(hist(:,7));
        [rowMax,~] = find(hist==sigmaMax);
        
        t = rowMax - 1;
        B = AGrey;        
        B(B <= t) = 0;
        B(B > t) = 255;
        
    
end    


function x = fixedPoint(x0,err,fun)
%calculate the x-value fulfilling x = fun(x) using fixed point iteration
%with x0 as start value, err as tolerance and fun the function equals
%to x, and boundary as the maximum pixel value.
    x = fun(x0);
    while x - x0 > err 
        x0 = x;
        x = fun(x0);
    end    
end           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%by Xiye Zhou
