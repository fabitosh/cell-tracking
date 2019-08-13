% Test Params
cellcore_image = imread('mask.jpg');
video = VideoReader('equal1.mp4'); 

% Let's go
cellcore_image = imread('mask.jpg');
video = VideoReader('equal1.mp4'); 
[mask, centroids] = FindMask(cellcore_image, false);
[frames] = TransformFrames(video); %start 120, end 210

structs = [];
for f = 1 : numel(frames)
    s = regionprops(mask, frames(f).img,{'Centroid','PixelValues','BoundingBox'});
    imshow(frames(f).img)
    title('Standard Deviation of Regions')
    hold on
    for k = 1 : numel(s())
        s(k).StandardDeviation = std(double(s(k).PixelValues));
        s(k).Mean = mean(double(s(k).PixelValues));
        text(s(k).Centroid(1),s(k).Centroid(2), ...
            sprintf('%2.1f', s(k).Mean), ...
            'EdgeColor','b','Color','r');
    end
    hold off
    structs = [structs, s()];
    clear s;
end