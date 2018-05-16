function labelIDs = swimsegPixelLabelIDs()
% Return the label IDs corresponding to each class.
%
% The SWIMSEG dataset has 2 classes.
%
% SWIMSEG pixel label IDs are provided as RGB color values with class 
% names listed alongside each RGB value. Note
% that the Other/Void class are excluded below.
labelIDs = { ...
    
    % "sky"
    [
    0 0 0; ... % RGB = Black
    ]
    
    % "cloud" 
    [
    255 255 255; ... % RGB = White
    ]   
    };
end

