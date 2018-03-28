clc;
clear all;
imaqreset;
vid=videoinput('winvideo',2,'YUY2_320x240');
preview(vid)
pause(15)

                    
a=getsnapshot(vid);
g=a(:,:,1);%to select red matrix write 1, green -2 , blue -3
imview(g);
log=roicolor(g,0,50);        %change the values according to estimate.m yellow(2):210 255,  blue(2):55 85,  red(1):155,175, 
log =clip(log);
IMVIEW(log);
