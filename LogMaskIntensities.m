function [cellIntensities] = LogMaskIntensities(mask, frames)
    cellIntensities = [];
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
        cellIntensities = [cellIntensities, s()];
        clear s;
    end
end

