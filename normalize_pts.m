%% Normalize a set of points
%
% Function for normalizing a set of points in order to be centered at the
% origin and have a root mean square (RMS) distance from the origin equal to the
% square root of the dimensionality of the (inhomogeneous) points.
%
% normalize_pts Normalize a set of points.
%
% [xn, T]= normalize_pts(x,dim,hom) normalizes the set of points x. If dim
% is given then points are considered to be stored along the dim dimension.
% E.g. if dim==2 then points are stored columnwise (default). Variable hom
% is a boolean stating if the points are in homogeneous form or not
% (default). The function returns the set of normalized points xn as the
% first output together with the normalizing transformation T (optional).

%% Beginning of normalize_pts function
%
function [xn,T] = normalize_pts(x,dim,hom)

%%%
% Treat default values for input variables.
if nargin < 3
    hom = false;
end
if nargin < 2
    dim = 2;
end

%%%
% Reshape set of points in a coherent way for all inputs.
if dim == 1
    x = x';
end
if hom
    x = x(1:end-1,:);
end

%%%
% Compute the number of points and their dimensionality.
[ptdim,npts] = size(x);

%%%
% Subtract the mean to center the points at the origin and store equivalent
% transformation. 
xm = mean(x,2);
xz = bsxfun(@minus,x,xm);

T1=eye(ptdim+1);
T1(1:ptdim,ptdim+1)=-xm;

%%%
% Note: The function 'bsxfun' is used here in order to perform singleton 
% expansion (if necessary). More specificaly as x has as many columns as the
% number of points, 'bsxfun' expands the vector xm in order to match the
% number of columns of x and then it applies elementwise the operator given as the 
% first argument. This can be also achieved with the 'repmat' function, but
% the way to expand the operand must be explicit in this case.

%%%
% Compute the RMS distance of the centered points and scale them in order
% to make it equal to the square root of their dimensionality. Store also
% the equivalent transformation.
rms = sqrt(sum(xz.^2,2)./npts);

xn = bsxfun(@times,xz,(sqrt(ptdim)./rms));

T2=eye(ptdim+1);
T2(1:ptdim,1:ptdim)=T2(1:ptdim,1:ptdim).*diag(sqrt(ptdim)./rms);

%%% 
% Combine the two transformations to obtain the normalization one.
T = T2*T1;

%%%
% Reshape the normalized points in the input form
if hom
    xn = [xn;ones(1,npts)];
end
if dim == 1
    xn = xn';
end    
    