I=imread('MATLAB\1.jpg');
imshow(I);
I2 = imcrop(I,[143 221 150 30]);
imshow(I2)