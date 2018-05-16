%--------------------------------------------------------------------------
% Author: Cayley Cruickshank DeFontes
% Purpose: Demo pixel-wise classifier for segmentation of NASA GLOBE Clouds 
% whole-sky cloud images and estimate sky-cloud cover for 
% 3 classes (sky, cloud, background)
% Created with MATLAB R2018a, 2018
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% SWIMSEG Images can be requested at:
% https://www.globe.gov/globe-data/visualize-and-retrieve-data
% -------------------------------------------------------------------------

% Import network from .MAT file
cd 'C:\Users\cayle\Desktop\GraphCut_CNN\3_classes\';
load(fullfile(cd, 'CNN_globe.mat'));

% Load network
disp("Network sucessfully loaded, getting images...")

% Create image datastore and pixel datastore
dataDir = fullfile(cd, 'images\');
imDir = fullfile(dataDir, 'images');
pxDir = fullfile(dataDir, 'GTmaps');

% Preview first image in imageDataStore
imds = imageDatastore(imDir);
I = preview(imds);
disp("Checking image dimensions...");
size(I)

% Declare classes and labelIDs (associated pixel value for each class)
% Classes, RGB values
% sky = red, [255 0 0]
% cloud = white, [255 255 255]
% background = black, [0 0 0]
classes = ["sky", "cloud", "background"];
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

% Calculate total cloud cover in segmented image
BG = rgb2gray(B);
BW = imbinarize(BG);
cloud_pixels = nnz(BW==1);
sky_pixels = nnz(BW~=1);
total_sky_area = cloud_pixels + sky_pixels;
cloud_cover = cloud_pixels/total_sky_area

% Test pixel-classification on single image
disp("Testing network on sample image, getting results...")
testImage = imread(fullfile(cd, 'images\images\0001b.jpg'));
imshow(testImage)
C = semanticseg(testImage, CNN_globe1);
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
disp("End of demo.")
