[filename, pathname] = uigetfile({'*.mp4;*.avi'}, 'Select a video file');
if isequal(filename,0) || isequal(pathname,0)
    disp('User canceled the file selection.');
    return;
else
    fullPath = fullfile(pathname, filename);
    disp(['User selected ', fullPath]);
end

video = VideoReader(fullPath);
firstFrame = readFrame(video);

fig = figure;
imshow(firstFrame);
title('Draw a bounding box on the image, release mouse when done');

h = drawrectangle('Label', 'Select Region', 'Color', 'red');
position = h.Position;

xmin = position(1);
ymin = position(2);
width = position(3);
height = position(4);
xmax = xmin + width;
ymax = ymin + height;

fprintf('Bounding Box Coordinates:\n');
fprintf('Top-Left: (%.2f, %.2f)\n', xmin, ymin);
fprintf('Top-Right: (%.2f, %.2f)\n', xmax, ymin);
fprintf('Bottom-Left: (%.2f, %.2f)\n', xmin, ymax);
fprintf('Bottom-Right: (%.2f, %.2f)\n', xmax, ymax);

video = VideoReader(fullPath); 
while hasFrame(video)
    frame = readFrame(video);

    frameWithBox = insertShape(frame, 'Rectangle', position, 'Color', 'red', 'LineWidth', 2);
    imshow(frameWithBox, 'Parent', fig.CurrentAxes);
    title('Video Playback');
    drawnow;
end

close(fig);

function pos = customWait(h)
    wait(h); 
    pos = h.Position;
end
