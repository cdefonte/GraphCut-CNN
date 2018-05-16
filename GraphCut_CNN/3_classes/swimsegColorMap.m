function cmap = swimsegColorMap()
% Define the colormap used by swimseg dataset.

cmap = [
    255 0 0        % sky, red
    255 255 255   % cloud, white
    0 0 0 % background, black
    
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end
