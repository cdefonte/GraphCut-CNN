function pixelLabelColorbar(cmap, classNames)
% Add a colorbar to the current axis. The colorbar is formatted
% to display the class names with the color.

colormap(gca,cmap)

% Add colorbar to current figure.
c = colorbar('peer', gca);

% Use class names for tick marks.
c.TickLabels = classNames;
numClasses = size(cmap,1);

% Center tick labels.
c.Ticks = 1/(numClasses*2):1/numClasses:1;

% Remove tick mark.
c.TickLength = 0;
end
function cmap = swimsegColorMap()
% Define the colormap used by swimseg dataset.

cmap = [
    0 0 0         % Sky
    255 255 255   % Cloud
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end