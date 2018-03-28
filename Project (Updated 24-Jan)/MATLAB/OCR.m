
% Load an image
I = imread('WB.jpg');
I2 = imtophat(I, strel('disk', 47));

% Perform morphological reconstruction and show binarized image.
marker = imerode(I2, strel('line',10,0));
Iclean = imreconstruct(marker, I2);
th = graythresh(Iclean);
BW = im2bw(Iclean, th);
figure;
imshow(BW);


% Initialize the blob analysis System object(TM)
blobAnalyzer = vision.BlobAnalysis('MaximumCount', 500);
% Run the blob analyzer to find connected components and their statistics.
[area, centroids, roi] = step(blobAnalyzer, BW);
% Show all the connected regions
img = insertShape(I, 'rectangle', roi);
figure;
imshow(img);

areaConstraint = area < 75500 & area>3000 ;
% Keep regions that meet the area constraint
roi = double(roi(areaConstraint, :));

% Show remaining blobs after applying the area constraint.
img = insertShape(I, 'rectangle', roi);
figure;
imshow(img);


% Perform OCR
results = ocr(BW,roi,'CharacterSet', '0123456789ABCDEFGHIJKLMNOPRSTUVWYZ','TextLayout', 'Block');

% Display one of the recognized words
word = results.Words{1}

% Location of the word in I
wordBBox = results.WordBoundingBoxes(1,:)

% Show the location of the word in the original image
%figure;
%Iname = insertObjectAnnotation(I, 'rectangle', wordBBox, word);
%imshow(Iname);

% Sort the character confidences
[sortedConf, sortedIndex] = sort(results.CharacterConfidences, 'descend');
% Keep indices associated with non-NaN confidences values
indexesNaNsRemoved = sortedIndex( ~isnan(sortedConf) );
% Get the top ten indexes
topTenIndexes = indexesNaNsRemoved(1:7);
% Select the top ten results
digits = num2cell(results.Text(topTenIndexes));
bboxes = results.CharacterBoundingBoxes(topTenIndexes, :);


Idigits = insertObjectAnnotation(I, 'rectangle', bboxes, digits);
figure;
imshow(Idigits);


