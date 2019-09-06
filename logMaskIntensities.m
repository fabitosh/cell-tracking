function [cellIntensities, mean_array] = logMaskIntensities(mask, frames)
    cellIntensities = [];
    nr_frames = numel(frames);
    nr_blobs = numel(regionprops(mask, frames(1).img));
    mean_array = NaN(nr_frames, nr_blobs);
    for f = 1 : nr_frames
        s = regionprops(mask, frames(f).img,{'Centroid','PixelValues','BoundingBox'});
%         imshow(frames(f).img)
%         title('Standard Deviation of Regions')
%         hold on
        for k = 1 : numel(s())
            s(k).StandardDeviation = std(double(s(k).PixelValues));
            blobmean = mean(double(s(k).PixelValues));
            s(k).Mean = blobmean;
            mean_array(f, k) = blobmean;
%             text(s(k).Centroid(1),s(k).Centroid(2), ...
%                 sprintf('%2.1f', s(k).Mean), ...
%                 'EdgeColor','b','Color','r');
        end
%         hold off
        cellIntensities = [cellIntensities, s()];
        clear s;
    end
end

