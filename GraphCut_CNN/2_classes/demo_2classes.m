%--------------------------------------------------------------------------
% Author: Cayley Cruickshank DeFontes
% Purpose: Demo pixel-wise classifier for segmentation of SWIMSEG 
% whole-sky cloud images and estimate sky-cloud cover for 
% 2 classes (sky, cloud)
% Created with MATLAB R2018a, 2018
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% SWIMSEG Images can be requested at:
% http://vintage.winklerbros.net/swimseg.html
% Data licensed under Creative Commons. Special thanks to:
% S. Dev, Y. H. Lee, S. Winkler.
% Color-based segmentation of sky/cloud images from ground-based cameras.
% IEEE Journal of Selected Topics in Applied Earth Observations and 
% Remote Sensing, vol. 10, no. 1, pp. 231-242, January 2017.
% -------------------------------------------------------------------------

% Import network from .MAT file
cd 'C:\Users\cayle\Desktop\GraphCut_CNN\2_classes\';
load(fullfile(cd, 'CNN_swimseg.mat'));

% Load network
disp("Network sucessfully loaded, getting images...")

% Create image datastore and pixel datastore
dataDir = fullfile(cd,'\images');
imDir = fullfile(dataDir, 'images');
pxDir = fullfile(dataDir, 'GTmaps');

% Preview first image in imageDataStore
imds = imageDatastore(imDir);
I = preview(imds);
disp("Checking image dimensions...");
size(I)

% Declare classes and labelIDs (associated pixel value for each class)
% Classes, RGB values
% sky = black, [0 0 0]
% cloud = white, [255 255 255]
classes = ["sky", "cloud"];
labelIDs = swimsegPixelLabelIDs;
labelDir = fullfile(dataDir, 'GTmaps');
pxds = pixelLabelDatastore(labelDir, classes, labelIDs);

% Preview image with label overlay as mask
C = readimage(pxds, 1);
cmap = swimsegColorMap;
B = labeloverlay(I, C, 'ColorMap', cmap);
imshow(B)
pixelLabelColorbar(cmap, classes);

% Table of class frequency; class distribution per pixel
tbl = countEachLabel(pxds)
frequency = tbl.PixelCount/sum(tbl.PixelCount);
bar(1:numel(classes), frequency)
xticks(1:numel(classes))
xticklabels(tbl.Name)
xtickangle(45)
ylabel('Frequency')

% Test pixel-classification on single image
disp("Testing network on sample image, getting results...")
testImage = read(imds);
imshow(testImage)
C = semanticseg(testImage,net);
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);

% Calculate total cloud cover in segmented image
BG = rgb2gray(B);
BW = imbinarize(BG);
total_sky_area = 224*224;
cloud_pixels = nnz(BW==1);
sky_pixels = total_sky_area - cloud_pixels;

cloud_cover = cloud_pixels/total_sky_area

% Compare network segmentation to Ground Truth map
% Mean BF Score = Boundary Contour Matching Score
expectedResult = read(pxds);
actual = uint8(C);
expected = uint8(expectedResult);
imshowpair(actual, expected)

% Evaluate network performance with Jaccard similarity coefficient
% to measure IoU (Intersection over Union)
pxdsResults = semanticseg(imds, net,'WriteLocation', tempdir,'Verbose', false);
metrics = evaluateSemanticSegmentation(pxdsResults, pxds,'Verbose', false);
Class_Metrics = metrics.ClassMetrics
Confusion_Matrix = metrics.ConfusionMatrix
disp("End of demo.");
