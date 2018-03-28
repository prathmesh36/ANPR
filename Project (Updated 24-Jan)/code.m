function varargout = code(varargin)
% CODE M-file for code.fig
%      CODE, by itself, creates a new CODE or raises the existing
%      singleton*.
%
%      H = CODE returns the handle to a new CODE or the handle to
%      the existing singleton*.
%
%      CODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CODE.M with the given input arguments.
%
%      CODE('Property','Value',...) creates a new CODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before code_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to code_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help code

% Last Modified by GUIDE v2.5 29-Dec-2015 18:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @code_OpeningFcn, ...
                   'gui_OutputFcn',  @code_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before code is made visible.
function code_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to code (see VARARGIN)

% Choose default command line output for code
handles.output = hObject;
clc
ser = serial('COM3');
% Update handles structure
handles.ser = ser;
guidata(hObject, handles);

% UIWAIT makes code wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = code_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cmd_start.
function cmd_start_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

ser = handles.ser;

% Video 1 code
% vid=videoinput('winvideo',1,'YUY2_320x240');
% videoRes = get(vid, 'VideoResolution');
% numberOfBands = get(vid, 'NumberOfBands');
% axes(handles.axes3)
% handleToImage = image( zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') ); 
% preview(vid,handleToImage)

vid1=videoinput('winvideo',2,'YUY2_320x240');
videoRes1 = get(vid1, 'VideoResolution');
numberOfBands = get(vid1, 'NumberOfBands');
axes(handles.axes2)
handleToImage1 = image( zeros([videoRes1(2), videoRes1(1), numberOfBands], 'uint8') );
preview(vid1,handleToImage1)

% preview(vid)
% preview(vid1)
pause(15)
a1=getsnapshot(vid1);
g=a1(:,:,1);%to select red matrix write 1, green -2 , blue -3
imtool(g);
log=roicolor(g,210,255);     
axes(handles.axes2)
imshow(log);
[lab1,num1]=bwlabel(log,8);
    %imtool(lab)
    sizeBlob1 = zeros(1,num1);
    j = 0;
    for i=1:num1,
    sizeblob1(i) = length(find(lab1==i));
    end
    [maxno largestBlobNo] = max(sizeblob1);
    outim = zeros(size(log),'uint8');
    outim(find(lab1==largestBlobNo)) = 1;
    last=255*outim;
    vehicle = 0;
    sizeblob1(largestBlobNo)
    if (sizeblob1(largestBlobNo)>3000)
        set(handles.txt_vehicle,'string','Vehicle Type:HMV');
        vehicle = 80;
    else
        set(handles.txt_vehicle,'string','Vehicle Type:LMV');
        vehicle = 40;
    end

%   sizeblob1  

%I=getsnapshot(vid);
I=imread('MATLAB\19.jpg');
axes(handles.axes3)
imshow(I);
%% Plate Extraction Code
figure(1); imshow(I);   
% Extract Y component (Convert an Image to Gray) 
Igray = rgb2gray(I);   
[rows cols] = size(Igray);   

%% Dilate and Erode Image in order to remove noise 
Idilate = Igray; 
for i = 1:rows    
    for j = 2:cols-1        
        temp = max(Igray(i,j-1), Igray(i,j));        
        Idilate(i,j) = max(temp, Igray(i,j+1));    
    end
end
I = Idilate; 
figure(2); 
imshow(Igray); 
figure(3);  
title('Dilated Image'); 
imshow(Idilate);   
figure(4);  
imshow(I);   
difference = 0;
sum = 0; 
total_sum = 0; 
difference = uint32(difference);   

%% PROCESS EDGES IN HORIZONTAL DIRECTION disp('Processing Edges Horizontally...'); 
max_horz = 0; maximum = 0; 
for i = 2:cols     
    sum = 0;     
    for j = 2:rows             
        if(I(j, i) > I(j-1, i))             
            difference = uint32(I(j, i) - I(j-1, i));         
        else
            difference = uint32(I(j-1, i) - I(j, i));         
        end
        if(difference > 20)             
            sum = sum + difference; 
        end
    end
    horz1(i) = sum;          
    % Find Peak Value     
    if(sum > maximum)      
        max_horz = i;
        maximum = sum; 
    end
    total_sum = total_sum + sum;
end
average = total_sum / cols;  
figure(5); 
% Plot the Histogram for analysis subplot(3,1,1); 
plot (horz1); 
title('Horizontal Edge Processing Histogram');
xlabel('Column Number ->');
ylabel('Difference ->');

%% Smoothen the Horizontal Histogram by applying Low Pass Filter disp('Passing Horizontal Histogram through Low Pass Filter...');
sum = 0; 
horz = horz1; 
for i = 21:(cols-21)    
    sum = 0;     
    for j = (i-20):(i+20) 
        sum = sum + horz1(j);   
    end
    horz(i) = sum / 41;
end
subplot(3,1,2);
plot (horz); 
title('Histogram after passing through Low Pass Filter');
xlabel('Column Number ->');
ylabel('Difference ->');  

%% Filter out Horizontal Histogram Values by applying Dynamic Threshold disp('Filter out Horizontal Histogram...'); 
for i = 1:cols   
    if(horz(i) < average) 
        horz(i) = 0;
        for j = 1:rows 
            I(j, i) = 0;  
        end
    end
end
subplot(3,1,3);
plot (horz); 
title('Histogram after Filtering'); 
xlabel('Column Number ->'); 
ylabel('Difference ->'); 
figure(10);
imshow(I);
%% PROCESS EDGES IN VERTICAL DIRECTION 
difference = 0; 
total_sum = 0;
difference = uint32(difference);  
disp('Processing Edges Vertically...');
maximum = 0;
max_vert = 0; 
for i = 2:rows     
    sum = 0;  
    for j = 2:cols  
        %cols       
        if(I(i, j) > I(i, j-1)) 
            difference = uint32(I(i, j) - I(i, j-1)); 
        end
        if(I(i, j) <= I(i, j-1))
            difference = uint32(I(i, j-1) - I(i, j)); 
        end
        if(difference > 20)
            sum = sum + difference;
        end
    end
    vert1(i) = sum;   
    %% Find Peak in Vertical Histogram   
    if(sum > maximum)     
        max_vert = i; 
        maximum = sum;  
    end
    total_sum = total_sum + sum; 
end
average = total_sum / rows;   
figure(6) 
subplot(3,1,1);
plot (vert1); 
title('Vertical Edge Processing Histogram'); 
xlabel('Row Number ->');
ylabel('Difference ->');   

%% Smoothen the Vertical Histogram by applying Low Pass Filter disp('Passing Vertical Histogram through Low Pass Filter...');
sum = 0; vert = vert1;   
for i = 21:(rows-21) 
    sum = 0; 
    for j = (i-20):(i+20)   
        sum = sum + vert1(j);  
    end
    vert(i) = sum / 41; 
end  
subplot(3,1,2); 
plot (vert); 
title('Histogram after passing through Low Pass Filter');
xlabel('Row Number ->'); 
ylabel('Difference ->');   

%% Filter out Vertical Histogram Values by applying Dynamic Threshold disp('Filter out Vertical Histogram...');
for i = 1:rows 
    if(vert(i) < average)  
        vert(i) = 0;    
        for j = 1:cols 
            I(i, j) = 0;   
        end
    end
end
subplot(3,1,3); 
plot (vert); 
title('Histogram after Filtering'); 
xlabel('Row Number ->'); 
ylabel('Difference ->');   
figure(7), 
imshow(I);   

%% Find Probable candidates for Number Plate 
j = 1; 
for i = 2:cols-2    
    if(horz(i) ~= 0 && horz(i-1) == 0 && horz(i+1) == 0)    
        column(j) = i;
        column(j+1) = i;   
        j = j + 2;   
    elseif((horz(i) ~= 0 && horz(i-1) == 0) || (horz(i) ~= 0 && horz(i+1) == 0))
        column(j) = i;   
        j = j+1;   
    end
end
j = 1; 
for i = 2:rows-2     
    if(vert(i) ~= 0 && vert(i-1) == 0 && vert(i+1) == 0)  
        row(j) = i;         
        row(j+1) = i;
        j = j + 2;   
    elseif((vert(i) ~= 0 && vert(i-1) == 0) || (vert(i) ~= 0 && vert(i+1) == 0))   
        row(j) = i;        
        j = j+1; 
    end
end
[temp column_size] = size (column); 
if(mod(column_size, 2)) 
    column(column_size+1) = cols; 
end
[temp row_size] = size (row); 
if(mod(row_size, 2))  
    row(row_size+1) = rows; 
end

%% Region of Interest Extraction 
%Check each probable candidate 
for i = 1:2:row_size   
    for j = 1:2:column_size    
        % If it is not the most probable region remove it from image   
        if(~((max_horz >= column(j) && max_horz <= column(j+1)) && (max_vert >= row(i) && max_vert <= row(i+1))))    
            %This loop is only for displaying proper output to User      
            for m = row(i):row(i+1)      
                for n = column(j):column(j+1)    
                    I(m, n) = 0;    
                end
            end
        end
    end
end
  
figure(8), 
imshow(I);

%%Cropping the Image
for i = 2:cols       
    for j = 2:rows
        if(I(j,i)~=0)
           temp_x=i;
           temp_y=j;
           break;
        end
    end
    if(I(j,i)~=0)
    break;
    end
end
x=temp_x;
y=temp_y;
for i=temp_x:cols
    for j=temp_y:rows
        if(I(j,i)~=0)
           temp_x=i;
           temp_y=j;
        end
    end
end

cl=temp_x-x;
ch=temp_y-y;
a=imcrop(I,[x+10 y cl-20 ch]);

%%Making it Perfect
% for i = 1:20      
%     for j = 1:ch
%         if(I2(j,i)<=150)
%             I2(j,1)=0;
%         end
%     end
% end

figure(9);
imshow(a);






g=a(:,:,1);%to select red matrix write 1, green -2 , blue -3
log=roicolor(g,0,100);        %change the values according to estimate.m yellow(2):210 255,  blue(2):55 85,  red(1):155,175, 
imagen =clip(log);
%imtool(log);
axes(handles.axes3)
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
%imtool(imagen);
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
        fid = fopen('text.txt', 'wt');
        fprintf(fid,'%s\n',word);
    else
        
    fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
    fprintf(fid,'%s\t',word);%Write 'word' in text file (upper)
    end
   
%     word=[];%Clear 'word' variable
    
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

[A,B,C] = xlsread('database.xlsx','Sheet3');
fid = fopen('text.txt', 'r');
% a = fscanf(fid,'%c');
% a = cellstr(a);
a = word;
x = a(1:10);

car1 = C(2,1);
car1 = cell2mat(car1);
% car1 = int2str(car1);

car2 = C(3,1);
car2 = cell2mat(car2);
% car2 = int2str(car2);

car3 = C(4,1);
car3 = cell2mat(car3);
% car3 = int2str(car3);

car4 = C(6,1);
car4 = cell2mat(car4);
% car4 = int2str(car4);
valid = 0;
if x == car1
    tts ('Valid car detected.');
    set(handles.txt_break,'string',car1);
    valid = 1;
elseif x == car2
    tts ('Valid car detected.');
    set(handles.txt_break,'string',car2);
    valid = 1;
elseif x == car3
    tts ('Valid car detected.');
    set(handles.txt_break,'string',car3);
    valid = 1;
elseif x == car4
    tts ('Valid car detected.');
    set(handles.txt_break,'string',car4);
    valid = 1;
else
    tts ('Car not registered.');
    set(handles.txt_break,'string','Car not registered.');
end

if valid == 1
    
    [A,B,C] = xlsread('database.xlsx','Sheet1');
    a = C(2,2);
    entry = cell2mat(a);
    entry1 = int2str(entry);
    d_cell = strcat('A', entry1);
    % winopen('text.txt')%Open 'text.txt' file
    fid = fopen('text.txt', 'r');
    a = fscanf(fid,'%c');
    b = strcat('Recognised Number Plate is',a);
    disp(b)
    set(handles.txt_plate,'string',a);
    a = cellstr(a);
    qwe = xlswrite('database.xlsx', a, 'Sheet1', d_cell);
    d_cell = 'B2';
    qwe = xlswrite('database.xlsx', (entry + 1), 'Sheet1', d_cell);
    tts (b);
    fclose(fid)
    fid = fopen('text.txt', 'r');
%     a = fscanf(fid,'%c');
     a = word;
     x = a(1:10);
    [A1,B1,C1] = xlsread('database.xlsx','Sheet2');
    a1 = C1(2,1);
    a1 = cell2mat(a1);
%     a1 = int2str(a1);
    a2 = C1(3,1);
    a2 = cell2mat(a2);
%     a2 = int2str(a2);
    if x == a1
        tts ('Alert! Stolen Vehicle Detected.');
        set(handles.txt_stolen,'string','Alert! Stolen Vehicle Detected.');
        fopen(ser);
        fprintf(ser,'E');
        pause(1)
        fprintf(ser,'X');
        fclose(ser);
    elseif x == a2
        tts ('Alert! Stolen Vehicle Detected.');
        set(handles.txt_stolen,'string','Alert! Stolen Vehicle Detected.');
        fopen(ser);
        fprintf(ser,'E');
        pause(1)
        fprintf(ser,'X');
        fclose(ser);
    else
        if vehicle == 40
            fopen(ser);
            fprintf(ser,'Q');
            pause(1)
            fprintf(ser,'X');
            fclose(ser);
        elseif vehicle == 80
            fopen(ser);
            fprintf(ser,'W');
            pause(1)
            fprintf(ser,'X');
            fclose(ser);
        end
            
            
    end
else
            fopen(ser);
            fprintf(ser,'R');
            pause(1)
            fprintf(ser,'X');
            fclose(ser);
end
    
    


guidata(hObject, handles);
