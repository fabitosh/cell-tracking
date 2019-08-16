function [mask] = CreateMask(input_image, perform_watershed)
 if ~exist('perform_watershed','var')
      perform_watershed = false;
 end
    %Import static image of cell nuclei (nuclei_im)
    nuclei_im = double(input_image);
    %Rescale image to [0,1]
    if true % SET TO TRUE WITH REAL IMAGE
        nuclei_im = (nuclei_im - min(nuclei_im(:))) / ...
        (max(nuclei_im(:)) - min(nuclei_im(:)));
    %To reduce the effect of very bright spots (artifacts) cap pixel
    %intensities at the 99th percentile
        cap_thresh = quantile(nuclei_im(:), 0.99);
        nuclei_im(nuclei_im >= cap_thresh) = cap_thresh;
    end
    %Smooth image
    conv_nuclei_im = imgaussfilt(nuclei_im, 5);
    conv_nuclei_im = imtophat(conv_nuclei_im, strel('disk', 10));
    thresh = graythresh(conv_nuclei_im);
    %Binarize the image 
    mask = (conv_nuclei_im >= 0.6 * thresh(end));
    if perform_watershed
        %Compute distance transform of the inverted binary image
        dist_transf = -bwdist(~mask); 
        %Set background to -Inf
        dist_transf(~mask) = -Inf;
        %Watershed image
        watersh_im = watershed(dist_transf);
        %The different objects now have a unique label and are enclosed by zero
        %pixels. Background is label 1
        %Binarize the image into foreground and background (or border) 
        mask = (watersh_im > 1);
    end
    %Perform blob analysis
    %Create blob object
    hblob = vision.BlobAnalysis( ...
                    'AreaOutputPort', false, ...
                    'BoundingBoxOutputPort', false, ...
                    'OutputDataType', 'single', ...
                    'MinimumBlobArea', 100, ...
                    'MaximumBlobArea', inf, ...
                    'MaximumCount', 2000, ...
                    'Connectivity', 4);
    centroids = hblob(mask);
    numBlobs = size(centroids,1);
    %Display result
%     subplot(1,2,1)
%     imshow(nuclei_im, []); hold on
%     scatter(centroids(:,1), centroids(:,2), 20,'+'); hold off
%     subplot(1,2,2)
%     imshow(mask, []); hold on
%     scatter(centroids(:,1), centroids(:,2), 20,'+'); hold off
    disp(['CreateMask() finished with ', num2str(numBlobs), ' Blobs'])
end

