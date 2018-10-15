

function [features] = get_features(image, x, y, feature_width)


image1=image;
%image1=padarray(image1,[16 16],0,'both');
Gx=[1, 1, 1;0, 0, 0;-1 -1 -1];
Gy=[1 0 -1;1 0 -1;1 0 -1];
Ix=imfilter(image1,Gx);
Iy=imfilter(image1,Gy);
Ix = padarray(Ix,[16 16],0,'both');
Iy = padarray(Iy,[16 16],0,'both');
MAGNITUDE=sqrt(Ix.^2+Iy.^2);
ORIENTATION=atan2(Iy,Ix);
features=[];
for i=1:size(x,1)
    Window=ORIENTATION((x(i)-7):(x(i)+8),(y(i)-7):(y(i)+8));
    Window_mag=MAGNITUDE((x(i)-7):(x(i)+8),(y(i)-7):(y(i)+8));
% 
    ang=zeros(size(Window));
    for n=1:size(Window,1)
        for m=1:size(Window,2)
        ang(n,m)=round((Window(n,m)*180/pi)/45)*45;
        end
    end
    H=[];
    h=[0,0,0,0,0,0,0,0];
    for a=1:4:size(ang,1)
        for b=1:4:size(ang,2)
            
            O=ang((a:a+3),(b:b+3));
            M=Window_mag((a:a+3),(b:b+3));
            for i=1:4
                for j=1:4
                    switch O(i,j)
                        case -180
                            h(1)=M(i,j);
                        case -135
                            h(2)=M(i,j);
                        case -90
                            h(3)=M(i,j);
                        case -45
                            h(4)=M(i,j);
                        case 0
                            h(5)=M(i,j);
                        case 45
                            h(6)=M(i,j);
                        case 90
                            h(7)=M(i,j);
                        case 135
                            h(8)=M(i,j);
                        case 180
                            h(1)=M(i,j);
                    end
                end
            end
           
            H=cat(2,H,h);
        end
    end
    H=H./max(H);
    features=cat(1,features,H);
    
end

end








