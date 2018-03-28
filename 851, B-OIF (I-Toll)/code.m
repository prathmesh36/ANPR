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
ser = serial('COM4');
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
vid=videoinput('winvideo',2,'YUY2_320x240');
videoRes = get(vid, 'VideoResolution');
numberOfBands = get(vid, 'NumberOfBands');
axes(handles.axes3)
handleToImage = image( zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') );

preview(vid,handleToImage)

vid1=videoinput('winvideo',1,'YUY2_320x240');
videoRes1 = get(vid1, 'VideoResolution');
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

a=getsnapshot(vid);
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
%         fid = fopen('text.txt', 'wt');
%         fprintf(fid,'%s\n',word);
    else
        
    %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
%     fprintf(fid,'%s\t',word);%Write 'word' in text file (upper)
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

car4 = C(5,1);
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
    set(handles.txt_stolen,'string','Car not registered.');
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
        set(handles.txt_stolen,'string','Stolen Vehicle');
        fopen(ser);
        fprintf(ser,'E');
        pause(1)
        fprintf(ser,'X');
        fclose(ser);
    elseif x == a2
        tts ('Alert! Stolen Vehicle Detected.');
        set(handles.txt_stolen,'string','Stolen Vehicle');
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
