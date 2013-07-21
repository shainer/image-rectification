function [] = test(path1, path2, corrPath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(corrPath);

subplot(1, 2, 1)
Image1 = imread(path1,'png');
subimage(Image1);
imshow(Image1);
axis off;
axis image;

hold on
title('First image');
plot(x(1, 1:8), x(2, 1:8), 'ro', 'MarkerSize', 3);
hold off

subplot(1, 2, 2)
Image2 = imread(path2,'png');
subimage(Image2);
imshow(Image2);
axis off;
axis image;

hold on
title('Second image');
plot(xp(1, 1:8), xp(2, 1:8), 'ro', 'MarkerSize', 3);
hold off

end
