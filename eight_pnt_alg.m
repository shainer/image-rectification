%% Fundamental matrix estimation using the 8-point algorithm 
% 
%%
% The description of the exercise can be found here:
% <http://www.dis.uniroma1.it/~visiope/exercises/ex6/ex6.pdf Exercise 6>.
%%
% As usual this is a reference implementation.

%% Initialization
% Clear the workspace.
clc
clear
close all

%%%
% Load the corresponding points.
load('corr_points.mat');

%% 8-point algorithm
%%%
% Normalize the two sets of points 
% (see <./normalize_pts.html normalize_pts>).
[xt, T] = normalize_pts(x,2,true);
[xpt, Tp] = normalize_pts(xp,2,true);

%%%
% Build A matrix.
nPts = size(x,2);
A = [xt(1,:).*xpt(1,:);xt(2,:).*xpt(1,:);xpt(1,:);xpt(2,:).*xt(1,:);...
     xpt(2,:).*xt(2,:);xpt(2,:);xt(1,:);xt(2,:);ones(1,nPts)]';

%%%
% Estimate fundamental matrix as the right singular vector corresponding to
% the smallest singular value of A.
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

%% Notes
% # You can verify that the computed fundamental matrix $\mathbf{F}$ is
% correct by using Exercise 5, substituting the given fundamental matrix
% with the computed one. The corresponding points given here are taken from
% the images of Exercise 5.