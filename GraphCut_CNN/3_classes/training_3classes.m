%--------------------------------------------------------------------------
% Author: Cayley Cruickshank DeFontes
% Purpose: Train a Convolutional Neural Network (CNN) to perform semantic
% segmentation of SWIMSEG whole-sky cloud images and estimate sky-cloud
% cover for 3 classes (sky, cloud, background)
% Created with MATLAB R2018a
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

% Create image datastore and pixel datastore
disp("Creating imageDatastore object...");
cd 'C:\Users\cayle\Desktop\GraphCut_CNN\3_classes\';
dataDir = fullfile(cd,'images\');
imDir = fullfile(dataDir, 'images');
pxDir = fullfile(dataDir, 'GTmaps');

% Preview first image in imageDataStore
imds = imageDatastore(imDir);
I = preview(imds);
size(I)

% Declare classes and labelIDs (associated pixel value for each class)
% Classes, RGB values
% sky = red, [255 0 0]
% cloud = white, [255 255 255]
% background, black [0 0 0]
classes = ["sky", "cloud", "background"];
labelIDs = swimsegPixelLabelIDs;
labelDir = fullfile(dataDir, 'GTmaps');

augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);

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

% Define network parameters and layers
disp("Creating network layers...")
inputSize = [224 224 3];
imgLayer = imageInputLayer(inputSize);

% Create downsampling network
filterSize = 3;
numFilters = 224;
conv = convolution2dLayer(filterSize, numFilters, 'Padding', 1);
relu = reluLayer();

% Create MaxPooling layer for downsampling
poolSize = 2;
maxPoolDownsample2x = maxPooling2dLayer(poolSize, 'Stride', 2);

% Stack convolution, ReLU, MaxPooling layers to create network that
% downsamples image input by a factor of 4 (reduced image size to 0.25x)
downsamplingLayers = [
    conv
    relu
    maxPoolDownsample2x
    conv
    relu
    maxPoolDownsample2x
    ]

% Create upsampling network
filterSize = 4;
transposedConvUpsample2x = transposedConv2dLayer(4,...
                            numFilters, ...
                            'Stride', 2, ...
                            'Cropping', 1);

upsamplingLayers = [
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ]

% Create pixel classification layer
numClasses = 3;
imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq;
pxLayer = pixelClassificationLayer('Name','labels',...
        'ClassNames',tbl.Name,...
        'ClassWeights',classWeights);
conv1x1 = convolution2dLayer(1, numClasses);
finalLayers = [
    conv1x1
    softmaxLayer()
    pixelClassificationLayer()
    ]

% Stack all layers
layers = [
    imgLayer
    downsamplingLayers
    upsamplingLayers
    finalLayers
    ]

% Training specifications and hyperparameters
% Reduce MiniBatchSize if memory is limited
opts = trainingOptions('adam', ...
    'InitialLearnRate',1e-4, ...
    'MaxEpochs',1, ...
    'MiniBatchSize',2, ...
    'Plots','training-progress');
disp("Network created, opening training visualization...")

% Begin training
% NOTE: In order to perform training, you will need to request access to
% SWIMSEG database in the link provided above. See ReadME for further
% information.
net.efficiency.memoryReduction = 4;
trainingData = pixelLabelImageDatastore(imds,pxds,'DataAugmentation', augmenter);
CNN_globe = trainNetwork(trainingData,layers,opts);

% Test output on single image
disp("Testing network on sample image, getting results...")
testImage = read(imds);
imshow(testImage)
C = semanticseg(testImage,CNN_globe);
B = labeloverlay(testImage,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);

% Compare network segmentation to Ground Truth map
expectedResult = read(pxds);
actual = uint8(C);
expected = uint8(expectedResult);
imshowpair(actual, expected)

% Evaluate network performance with Jaccard function to measure IoU
pxdsResults = semanticseg(imds,...
            CNN_globe,...
            'WriteLocation',tempdir,...
            'Verbose',false);
        
metrics = evaluateSemanticSegmentation(pxdsResults,pxds,'Verbose',false);
metrics.DataSetMetrics
metrics.ClassMetrics
