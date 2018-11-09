%bilinearSpline.m
%A 3*3 matrix A is given, this script calculates the bilinearly interpolated
%matrix of A and visulizes the original matrix A and interplated matrix u
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = [69,110,196;50,226,101;210,100,206]; % load matrix 

%split the matrix A into 4 subregions, then put the subregion matrices in a cell with 4 "boxes"
subregions = cell(1,4); 
subregions{1} = A(1:2,1:2);
subregions{2} = A(1:2,2:3);
subregions{3} = A(2:3,1:2);
subregions{4} = A(2:3,2:3);

[x,y] = meshgrid(0:0.05:1); %ranges of x and y for interpolation calculation
subResult = cell(1,4); %put the interpolation results for each subregion in a cell with 4 "boxes"

for k = 1:length(subregions) %for each subregion...
    subregionInterp = zeros(size(x)); %matrix for storing the interpolation results of each subregion
    for i = 1:size(x,1) %for each row in the subregion...
        for j = 1:size(x,2) %for each column element in the row...
            %calculate the interpolation result using an internal function
            %"biliearInterp".
            subregionInterp(i,j) = bilinearInterp(subregions{k},x(i,j),y(i,j)); 
        end
    end
    subResult{k} = subregionInterp; %put the results of each subregion in the corresponding result "box"
end

%combine results of subregions 1 and 2 into topResult. Since the right edge of 1 and the
%left edge of 2 overlap each other, the left edge of 2 (i.e. the first
%column of 2) must be removed. This rule also applies for the left edge of
%4 in bottomResult.
topResult = [subResult{1},subResult{2}(:,2:end)]; 
bottomResult = [subResult{3},subResult{4}(:,2:end)];
%combine topResult and bottomResult into final result u. Since the bottom of
%topResult and top of bottomResult overlap each other, the first row of
%bottomResult is removed.
u = [topResult;bottomResult(2:end,:)];

%graphical results
figure(1), surf(A) %show original matrix A
[xResult,yResult] = meshgrid(1:0.05:3);
figure(2),surf(xResult,yResult,u); %show interpolated matrix u

function output = bilinearInterp(input,alpha,beta)
%given a square matrix with four values on the corners, the interpolated 
%values on position (alpha,beta) in the square is calculated and returned as
%output.
%input should be a 2*2 square matrix [u1,u2;u3,u4].
%alpha, beta are parameters for linear interpolation and show the position
%in the square matrix.
    output = (1 - alpha) * (1 - beta) * input(1,1) + ...
              alpha * (1 - beta) * input(1,2) + ...
             (1 - alpha) * beta * input(2,1) + ...
              alpha * beta * input(2,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%by Xiye Zhou
