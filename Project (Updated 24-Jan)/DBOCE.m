clc;    
% Clearvcxa command window. 
clear all;  
% Delete all variables. 
close all;  
% Close all figure windows except those created by imtool. 
imtool close all;   
% Close all figure windows created by imtool. 
workspace;  
% Make sure the workspace panel is showing.   
% Read Image 
I = imread ('form4.jpg');   
figure(1); 
pausez=imshow(I);
waitfor(pausez);   
% Extract Y component (Convert an Image to Gray) 
Igray = rgb2gray(I);   
[rows cols] = size(Igray);   
imshow(Igray);
BW = edge(Igray,'Canny')
imshow(BW)
%%imwrite(BW,'res.png')
imshow(I)
count=0
cc = bwconncomp(BW);
measurements = regionprops(cc, 'BoundingBox');
for k = 1 : length(measurements)
  thisBB = measurements(k).BoundingBox;
  if   (thisBB(4) <= 7 && thisBB(3)>300) % this condition is for identifiying lines (thisBB(4) >= 50 && thisBB(4) <= 70 && thisBB(3)>=50 && thisBB(3)<=70) ||
    rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'FaceColor',[0 .5 .5],'EdgeColor','b',...
    'LineWidth',3)
    count=count+1
%%
            %{
            if thisBB(4) >= 50 && thisBB(4) <= 70 && thisBB(3)>=50 && thisBB(3)<=70
                a=imcrop(I,[thisBB(1)+2,thisBB(2)+2,thisBB(3)-5,thisBB(4)-5])
            else
            %}
                a=imcrop(I,[thisBB(1),thisBB(2)-50,thisBB(3),50])  % croping area above line
            %end
            
            pausez=imshow(a);
            waitfor(pausez);
            
            
            g=a(:,:,1);                   %to select red matrix write 1, green -2 , blue -3
            log=roicolor(g,0,100);        %change the values according to estimate.m yellow(2):210 255,  blue(2):55 85,  red(1):155,175, 
            imagen =clip(log);
            %imtool(log);
            %axes(handles.axes3)
            %imshow(imagen);        
            word=[];%Storage matrix word from image
            re=imagen;
            %Opens text.txt as file for write
            fid = fopen('text.txt', 'at');
            while 1
                [fl re]=lines(re);%Fcn 'lines' separate lines in text
                rq=fl;
                while 1
                   [fl1 rq]=columns(rq);  
                imgn=~fl1;
                %*-*Uncomment line below to see lines one by one*-*-*-*
                   % imtool(fl);pause(1)
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
                    letter=genetic(img_r);%img to text
                    word=[word letter];
                end
                if isempty(rq)
                    fprintf(fid,'%s\n',word);
                else

                fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
                fprintf(fid,'%s\t',word);%Write 'word' in text file (upper)
                end

                if isempty(rq)  %See variable 're' in Fcn 'lines'
                    break
                end
                end
                if isempty(rq)
                   if isempty(re)
                       break
                   end
                end

                
                %*-*-*When the sentences finish, breaks the loop*-*-*-*

                %*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
             
            end
            fclose(fid);
            
  end
end
%%rectangle('Position',[197,63,396,4]);

saveas(gcf,'final.png')


