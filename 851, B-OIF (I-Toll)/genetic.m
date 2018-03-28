function o_let=genetic(imagen)

%%define training folder
filesList = dir(strcat(pwd,'\TrainingData\*.bmp'));
    filesListCount = size(filesList,1);
    
   
    diffVariance = 0;
  %%define input image
    a=imagen;
     inputImage(:,:,1)=a;
     %imtool(inputImage)

   goa1 = size(find(inputImage));
   goal = goa1(1,1);
   %%1 times iteration for optimal match
for i=1:1 
    diffVariance = diffVariance + 1; %Modify Variance value between output image and training image
       
            for filesListCounter = 1: filesListCount
                
                % done  Mutation                      
                trainingImage = imread(strcat(pwd,'\TrainingData\',filesList(filesListCounter).name));   
                 % trainingImage=double(trainingImage);
                  b = filesList(filesListCounter).name;
                  len_file = length(b);
                    len_file = len_file - 4;
                    for i = 1 : len_file;
                        o_file(1,i) = b(1,i);
                    end
                trainingImageRedPixelInfo = trainingImage(:,:,1);
                inputImageWhitePixelInfo = inputImage(:,:,1);
                trainingDataFitness = corr2(trainingImageRedPixelInfo,inputImageWhitePixelInfo);
                
                 daq(filesListCounter,1) = o_file;%index
              daq1(filesListCounter,1) = trainingDataFitness*goal; % computation
              daq2(filesListCounter,2) = 1 - trainingDataFitness; % computation
             
                    
           end
end
max_val = max(daq1);
index = find(daq1 == max_val);
o_let = daq(index);
 
