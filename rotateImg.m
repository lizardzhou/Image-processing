function [B] = rotateImg(A,phi,method)
%ROTATEIMG
%
%rotate a zero padded image matrix A by a given angle phi. An interpolation
%method in string form should serve as input parameter as well, either 
%'nearestneighbor' or 'bilinear'.
%
%See also imrotate.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rotated image has the same size as padded image. 
%For later matrix calculation it should have uint8 data type.
rotImg = uint8(zeros(size(A))); 

%determine the original point (xMid,yMid).
xMid = ceil((size(A,1) + 1) / 2);
yMid = ceil((size(A,2) + 1) / 2);

%rotation from pixel to pixel: (x,y) is the coordinate in original padded
%image and (i,j) is the coordinate in rotated image. The rotation center is
%no more (0,0), thus the coordinate in rotated image must be adjusted, i.e.
%(i-xMid,y-xMid).
for i = 1:size(rotImg,1) %for each row in the rotated image...
    for j = 1:size(rotImg,2) %for each column element in a row...
        %the coordinate in the rotated image (output) is mapped to the corresponding 
        %coordinate in original image (input), thus the transpose of the
        %rotation matrix is used.
        x = (i- xMid) * cos(phi) + (j - yMid) * sin(phi);  
        y = -(i- xMid) * (sin(phi)) + (j - yMid) * cos(phi);
        x = x + xMid;
        y = y + yMid;
        
        %transfer pixel values of those pixels belong to the original image
        if (x >= 1  && y >=1 && x <= size(A,1) && y <= size(A,2))
            switch method
                case 'nearestneighbor'
                    x = round(x);
                    y = round(y);
                    intermediateResult = A(x,y);
                case 'bilinear'
                    %the position (x,y) is surrounded by other 4 neighbor pixels. Get those pixel values for
                    %bilinear interpolation
                    surroundingPixelValues =[A(floor(x),floor(y)),A(ceil(x),floor(y));A(floor(x),ceil(y)),A(ceil(x),ceil(y))];
                    alpha = x - floor(x);
                    beta = y - floor(y);
                    intermediateResult = (1 - alpha) * (1 - beta) * surroundingPixelValues(1,1) + ...
                                          alpha * (1 - beta) * surroundingPixelValues(1,2) + ...
                                         (1 - alpha) * beta * surroundingPixelValues(2,1) + ...
                                          alpha * beta * surroundingPixelValues(2,2);
                otherwise
                    disp('Unknown method!');
                    return
            end   

            %pixel value of position (x,y) in the original image is transfered to the
            %rotated image at corresponding position (i,j).
            rotImg(i,j) = intermediateResult;
        end
    end
end

B = rotImg;
%figure, imshow(B)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%by Xiye Zhou
