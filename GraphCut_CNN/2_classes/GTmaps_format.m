function results = GTmaps_format(im)
%Image Processing Function
%
% IM      - Input image.
% RESULTS - A scalar structure with the processing results.
%
%--------------------------------------------------------------------------
% Usage:
% After obtaining the SWIMSEG database of images, binary ground truth maps
% need to be converted to RGB image of dimension 224 x 224 x 3.
% Resizing images will cause deformations to binary mask. The following
% function can be called to the entire directory of ground truth maps
% using the imageBatchProcessor UI.
% The pixel Datastore requires ground truth maps to be RGB images with only
% those values corresponding to pixel class labels.%
% When used by the App, this function will be called for every input image
% file automatically. IM contains the input image as a matrix. RESULTS is a
% scalar structure containing the results of this processing function.
%
%--------------------------------------------------------------------------

if(size(im, 3)~=3 && size(im, 1) ~= 224 && size(im, 2) ~= 224)
    im_resize = imresize(im, [224, 224]);
    im_3d = cat(3, im_resize, im_resize, im_resize);
    im_gray = rgb2gray(im_3d);
    im_bw = imbinarize(im_gray);
    im_bw_3d = cat(3, im_bw, im_bw, im_bw);
    im_uint8 = im2uint8(im_bw_3d);
else
    im_uint8 = im;
end

results.GTmaps_format = im_uint8;

%--------------------------------------------------------------------------
