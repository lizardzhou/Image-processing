%fullRotation.m
%zero pad the image alfred_gr.png and rotate it completely (rotation by 2*pi) by different
%angles phi (pi/16, pi/8, pi/4 and pi/2) using 3 interpolating methods given in
%string form ('nearestneighbor', 'bilinear' and 'bicubic'). The mean
%squared error before and after the rotation is compared for each method in
%dependence of phi.
%ATTENTION: LONG RUNTIME UP TO 4 MINUTES DEPENDING ON HARDWARE SPECS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%zero padding the image "alfred_gr.png"
A = imread('alfred_gr.png');
[p,Ap] = padImg(A);

angles = [pi/16,pi/8,pi/4,pi/2];

%image rotation using interpolation method 'nearestneighbor'
ApNear16 = Ap; ApNear8 = Ap; ApNear4 = Ap; ApNear2 = Ap;
for i1 = 1:32
    ApNear16 = rotateImg(ApNear16,angles(1),'nearestneighbor');
end
errNear16 = immse(double(Ap),double(ApNear16));

for j1 = 1:16
    ApNear8 = rotateImg(ApNear8,angles(2),'nearestneighbor');
end
errNear8 = immse(double(Ap),double(ApNear8));

for k1 = 1:8
    ApNear4 = rotateImg(ApNear4,angles(3),'nearestneighbor');
end
errNear4 = immse(double(Ap),double(ApNear4));

for l1 = 1:4
    ApNear2 = rotateImg(ApNear2,angles(4),'nearestneighbor');
end
errNear2 = immse(double(Ap),double(ApNear2));

errNear = [errNear16,errNear8,errNear4,errNear2];


%image rotation using interpolation method 'bilinear'
ApBilin16 = Ap; ApBilin8 = Ap; ApBilin4 = Ap; ApBilin2 = Ap;
for i2 = 1:32
    ApBilin16 = rotateImg(ApBilin16,angles(1),'bilinear');
end
errBilin16 = immse(double(Ap),double(ApBilin16));

for j2 = 1:16
    ApBilin8 = rotateImg(ApBilin8,angles(2),'bilinear');
end
errBilin8 = immse(double(Ap),double(ApBilin8));

for k2 = 1:8
    ApBilin4 = rotateImg(ApBilin4,angles(3),'bilinear');
end
errBilin4 = immse(double(Ap),double(ApBilin4));

for l2 = 1:4
    ApBilin2 = rotateImg(ApBilin2,angles(4),'bilinear');
end
errBilin2 = immse(double(Ap),double(ApBilin2));

errBilin = [errBilin16,errBilin8,errBilin4,errBilin2];


%image rotation using interpolation method 'bicubic'
ApBicu16 = Ap; ApBicu8 = Ap; ApBicu4 = Ap; ApBicu2 = Ap;
for i3 = 1:32
    ApBicu16 = imrotate(ApBicu16,angles(1)*180/pi,'bicubic','crop');
end
errBicu16 = immse(double(Ap),double(ApBicu16));

for j3 = 1:16
    ApBicu8 = imrotate(ApBicu8,angles(2)*180/pi,'bicubic','crop');
end
errBicu8 = immse(double(Ap),double(ApBicu8));

for k3 = 1:8
    ApBicu4 = imrotate(ApBicu4,angles(3)*180/pi,'bicubic','crop');
end
errBicu4 = immse(double(Ap),double(ApBicu4));

for l3 = 1:4
    ApBicu2 = imrotate(ApBicu2,angles(4)*180/pi,'bicubic','crop');
end
errBicu2 = immse(double(Ap),double(ApBicu2));

errBicu = [errBicu16,errBicu8,errBicu4,errBicu2];

%error plotting
figure, 
plot(angles,errNear,'b-*',angles,errBilin,'r-*',angles,errBicu,'g-*');
xlabel('Angle in radian');
ylabel('Mean squared error');
legend('Nearest neighbor interpolation','Bilinear interpolation','bicubic interpolation');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%by Xiye Zhou
