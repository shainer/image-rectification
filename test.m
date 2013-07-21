function [] = test(path1, path2, corrPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(corrPath);

subplot(1, 2, 1)
Image1 = imread(path1,'png');
subimage(Image1);
imshow(Image1);

hold on
title('First image');
plot(x(1, 1:8), x(2, 1:8), 'ro', 'MarkerSize', 3);
hold off

subplot(1, 2, 2)
Image2 = imread(path2,'png');
subimage(Image2);
imshow(Image2);

hold on
title('Second image');
plot(xp(1, 1:8), xp(2, 1:8), 'ro', 'MarkerSize', 3);
hold off

[xt, T] = normalize_pts(x, 2, true);
[xpt, Tp] = normalize_pts(xp, 2, true);

nPts = size(x,2);
A = [xt(1,:).*xpt(1,:);xt(2,:).*xpt(1,:);xpt(1,:);xpt(2,:).*xt(1,:);...
     xpt(2,:).*xt(2,:);xpt(2,:);xt(1,:);xt(2,:);ones(1,nPts)]';
 
[U,S,V] = svd(A);
f = V(:,end);
Ft = reshape(f,3,3)';

%%% 
% Enforce the singularity constraint by computing the matrix which is
% "closest" to the computed one, under the Frobenious norm, and has rank 2.
% This is easily achived, using the SVD of the matrix, by substituting the 
% necessary number of smaller singular values with zeros (one in this case).
[UF,SF,VF] = svd(Ft);
Ftp = UF*diag([SF(1,1),SF(2,2),0])*VF';

%%% 
% Denormalization
F = Tp'*Ftp*T;
e1 = null(F);
e1 = e1 / e1(3);
e2 = null(transpose(F));
e2 = e2 / e2(3);

angle = atan2(e2(2), e2(1));

R = [cos(-angle), -sin(-angle), 0; sin(-angle), cos(-angle), 0; 0, 0, 1];
e2OnX = R * e2;
G = [1, 0, 0; 0, 1, 0; -1/e2OnX(1), 0, 1];
H2 = G * R;

H2 = maketform('affine', H2);
Image2 = imtransform(Image2, H2);

subimage(Image2);
imshow(Image2);

hold on
title('Second image warped');
plot(xp(1, 1:8), xp(2, 1:8), 'ro', 'MarkerSize', 3);
hold off

end
