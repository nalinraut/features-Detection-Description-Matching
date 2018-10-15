% Local Feature Stencil Code
% Written by James Hays for CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.

function [x, y] = get_interest_points(image, feature_width)

sigma=1;
filterG = fspecial('Gaussian',4, sigma);

image= padarray(image,[16 16],0,'both');

Gx=[-1, 0, 1; -1, 0, 1; -1, 0, 1];
Gy=[-1, -1, -1; 0, 0, 0; 1, 1, 1];

Ix=conv2(Gx,image);
Iy=conv2(Gy,image);
Ixx=Ix.^2;
Iyy=Iy.^2;
Ixy=Ix.*Iy;


gIxx = conv2(filterG,Ixx);
gIyy = conv2(filterG,Iyy);
gIxy = conv2(filterG,Ixy);


M=[gIxx, gIxy;gIxy, gIyy];
k = 0.15;
threshold = 0.08;        
har = ((gIxx.*gIyy) - (gIxy.^2)) - k*((gIxx.^2 + gIyy.^2).^2);
%har = ((gIxx.*gIyy) - (gIxy.^2))./(gIxx.^2 + gIyy.^2);



for i=1 : size(har,1)
    for j = 1:size(har,2)
        if har(i,j) > threshold
            har(i,j) = har(i,j);
            
        else
            har(i,j) = 0;
        end
    end
end 

Rnonmaxsup = har > imdilate(har, [1 1 1; 1 0 1; 1 1 1]);
x=[];
y=[];

for k=1 : size(Rnonmaxsup,1)
    for l = 1:size(Rnonmaxsup,2)
        if Rnonmaxsup(k,l)==1
            x=cat(1,x,k);
            y=cat(1,y,l);
        end
    end
end
end

