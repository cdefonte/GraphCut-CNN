Welcome to the GraphCut-CNN homepage!

This project was created in order to enable users to perform semantic segmentation of ground-based whole sky images obtained from Singapore Whole-Sky Imaging Segmentation Database (SWIMSEG) and NASA GLOBE Clouds Citizen Science images from Arctic research campaigns using convolutional neural networks (CNN). This particular codebase uses MATLAB R2018a as well as the MATLAB Image Processing and Deep Learning toolkits.

For those interested in using the trained network pipeline on SWIMSEG images, feel free to use the demo_2classes.m script found in the 2 classes folder (sky, cloud classes). This allows users to perform semantic segmentation of sky-cloud patches and estimate cloud cover. A sample image has been provided for those interested only in the demonstration. For those instances in which whole-sky images are unavailable and images in the foreground must be removed, a demo and training version has been provided that combines GraphCut 'foreground subtraction' and semantic segmentation using convolutional neural networks. Demo and training files have been provided, as well.

To use: Demo Files with Pre-trained network

Download this repository.
Open MATLAB and run: a. For 2-class demo (sky, cloud segmentation): C:*\GraphCut_CNN\2_classes\demo_2classes.m b. For 3-class demo (sky, cloud, background segmentation): C:*\GraphCut_CNN\3_classes\demo_3classes.m
To use: For training network on 2 classes (sky, cloud)

Download this repository.
Request SWIMSEG images from http://vintage.winklerbros.net/swinseg.html.
Open MATLAB and run C:*\GraphCut_CNN\2_classes.m
I am currently working on making the NASA GLOBE Clouds Program Arctic research images available for download. Similar images can be found through the NASA GLOBE Visualization Tool and selecting 'Clouds' to filter observations: https://www.globe.gov/globe-data/visualize-and-retrieve-data

For more information about the project methodologies, background, and results, view the .PPT included in the 'GraphCut-CNN/output_images' folder.

Special thanks to Vision & Interactive Group for providing access to SWIMSEG images.

S. Dev, F. M. Savoy, Y. H. Lee, S. Winkler. Nighttime sky/cloud image segmentation. Proc. IEEE International Conference on Image Processing (ICIP), Beijing, China, Sep. 17-20, 2017
