clc, close all, clear all
imagen=imread('scanner.bmp');
imshow(imagen);title('Input with noise')

%Filter with noise%
if length(size(imagen))==3;
    imagen=rgb2gray(imagen);
end
imagen= medfilt2(imagen);
%imview(imagen);
[f c]=size(imagen);
imagen (1,1)=255;
imagen (f,1)=255;
imagen (1,c)=255;
imagen (f,c)=255;
%END Filter Image Noise*
%imview(imagen)
aa=clip(imagen);
imview(aa);
r=size(aa,1)
for s=1:r   %execute the for routine from 1 to no. of rows
    if sum(aa(s,:))==0  %checking for empty row
        nm=aa(1:s-1,1:end);%First line matrix
        rm=aa(s:end,1:end);%Remain line matrix
        fl=~clip(~nm);
        re=~clip(~rm);
        s
        
                 subplot(2,1,1);imshow(fl);
                 subplot(2,1,2);imshow(re);
        break
    else
        s
        fl=~aa;%Only one line.(invert image)
        re=[];  %empty the variable re
    end
end

imgn=~fl;   %invert image
L = bwlabel(imgn);  %label the connected pixels
mx=max(max(L)); %returns no. of characters in a line
