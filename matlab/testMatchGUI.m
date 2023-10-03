clc; clear;

load('../data/someCorresp.mat');
img1=imread('../data/im1.png');
img2=imread('../data/im2.png');
load('2_1.mat');
[coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);



load('../data/templeCoords.mat');
[ P, error ] = triangulate( M1, p1, M2, p2 );


