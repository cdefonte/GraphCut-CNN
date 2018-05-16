function cmap = swimsegColorMap()
% Define the colormap used by swimseg dataset.

cmap = [
    0 0 0        % Sky
    255 255 255   % Cloud
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end
