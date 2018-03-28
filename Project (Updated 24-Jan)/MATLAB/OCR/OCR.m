warning off
clc, close all, clear all
z=0;
imagen=imread('heavy_metal.bmp');%Read Binary Image
imshow(imagen);%title('INPUT IMAGE WITH NOISE')
%*-*-*Filter Image Noise*-*-*-*
if length(size(imagen))==3 %RGB image
    imagen=rgb2gray(imagen);
end
imagen = medfilt2(imagen);
[f c]=size(imagen);
imagen (1,1)=255;
imagen (f,1)=255;
imagen (1,c)=255;
imagen (f,c)=255;
%imview(imagen);
%*-*-*END Filter Image Noise*-*-*-*
word=[];%Storage matrix word from image
re=imagen;
fid = fopen('text.txt', 'wt');%Opens text.txt as file for write
while 1
    [fl re]=lines(re);%Fcn 'lines' separate lines in text
    rq=fl;
    while 1
       [fl1 rq]=columns(rq);  
    imgn=~fl1;
    %*-*Uncomment line below to see lines one by one*-*-*-*
       % imview(fl);pause(1)
    %*-*--*-*-*-*-*-*-
    %*-*-*-*-*-Calculating connected components*-*-*-*-*-
    L = bwlabel(imgn);
    mx=max(max(L));
    BW = edge(double(imgn),'sobel');
    [imx,imy]=size(BW);
    for n=1:mx
        [r,c] = find(L==n);
        rc = [r c];
        [sx sy]=size(rc);
        n1=zeros(imx,imy);
        for i=1:sx
            x1=rc(i,1);
            y1=rc(i,2);
            n1(x1,y1)=255;
        end
        %*-*-*-*-*-END Calculating connected components*-*-*-*-*
        n1=~n1;
        n1=~clip(n1);
        img_r=same_dim(n1);%Transf. to size 42 X 24
        %*-*Uncomment line below to see letters one by one*-*-*-*
                %imshow(img_r);pause(1)
        %*-*-*-*-*-*-*-*
        %letter=read_letter(img_r);%img to text
        %word=[word letter];
    end
%     if isempty(rq)
%         fprintf(fid,'%s\n',word);
%     else
%         
%     %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
%     fprintf(fid,'%s\t',word);%Write 'word' in text file (upper)
%     end
%    
%     word=[];%Clear 'word' variable
%     
%     if isempty(rq)  %See variable 're' in Fcn 'lines'
%         break
%     end
%     end
%     if isempty(rq)
%        if isempty(re)
%            break
%        end
     end
       
    %*-*-*When the sentences finish, breaks the loop*-*-*-*
    
    %*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
end

fclose(fid);
winopen('text.txt')%Open 'text.txt' file
fid = fopen('text.txt', 'r');
a = fscanf(fid,'%c');
tts (a);
fclose(fid)
