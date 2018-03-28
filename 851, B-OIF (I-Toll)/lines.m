function [fl re]=lines(aa)

aa=clip(aa);    %Crop the image to size and invert it
r=size(aa,1);   %returns no of rows
for s=1:r   %execute the for routine from 1 to no. of rows
    if sum(aa(s,:))==0  %checking for empty row
        nm=aa(1:s-1,1:end);%First line matrix
        rm=aa(s:end,1:end);%Remain line matrix
        fl=~clip(~nm);
        re=~clip(~rm);
        %*-*-*Uncomment lines below to see the result*-*-*-*-
                 %subplot(2,1,1);imshow(fl);
                 %subplot(2,1,2);imshow(re);
                 %imview(fl)
        break
    else
        fl=~aa;%Only one line.(invert image)
        re=[];  %empty the variable re
    end
end