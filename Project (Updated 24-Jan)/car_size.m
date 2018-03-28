clc
clear all
imaqreset
vid1=videoinput('winvideo',1,'YUY2_320x240');
preview(vid1)
pause(5)

a1=getsnapshot(vid1);
g=a1(:,:,1);%to select red matrix write 1, green -2 , blue -3
imview(g);
log=roicolor(g,200,255);     
imshow(log);
[lab1,num1]=bwlabel(log,8);
    imview(lab1)
    sizeBlob1 = zeros(1,num1);
    j = 0;
    for i=1:num1,
    sizeblob1(i) = length(find(lab1==i));
    end
    [maxno largestBlobNo] = max(sizeblob1);
    outim = zeros(size(log),'uint8');
    outim(find(lab1==largestBlobNo)) = 1;
    last=255*outim;
    imshow(last);
    vehicle = 0;
    sizeblob1(largestBlobNo)
    if (sizeblob1(largestBlobNo)>3000)
        vehicle = 80
    else
        vehicle = 40
    end
    
    
 