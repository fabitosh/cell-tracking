%Import static image of cell nuclei (nuclei_im)
load('datastack1/08.01.2019_1_hTC_P268_p8_d5_+AA_S2__1.mat')
nuclei_im = double(nuclei_im);
%Rescale image to [0,1]
nuclei_im = (nuclei_im - min(nuclei_im(:))) / ...
    (max(nuclei_im(:)) - min(nuclei_im(:)));
%To reduce the effect of very bright spots (artifacts) cap pixel
%intensities at the 99th percentile
cap_thresh = quantile(nuclei_im(:), 0.99);
nuclei_im(nuclei_im >= cap_thresh) = cap_thresh; 
%Smooth image
conv_nuclei_im = imgaussfilt(nuclei_im, 5);
conv_nuclei_im = imtophat(conv_nuclei_im, strel('disk', 10));
thresh = graythresh(conv_nuclei_im);
%Binarize the image 
conv_nuclei_im_log = (conv_nuclei_im >= 1.0 * thresh(end));
%Compute distance transform of the inverted binary image
dist_transf = -bwdist(~conv_nuclei_im_log); 
%Set background to -Inf
dist_transf(~conv_nuclei_im_log) = -Inf;
%Watershed image
watersh_im = watershed(dist_transf);
%The different objects now have a unique label and are enclosed by zero
%pixels. Background is label 1
%Binarize the image into foreground and background (or border) 
watersh_im_log = (watersh_im > 1);
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
centroid_list = hblob(watersh_im_log);
numBlobs = size(centroid_list,1);
%Display result
subplot(1,2,1)
imshow(nuclei_im, []); 
hold on
scatter(centroid_list(:,1), centroid_list(:,2), 20,'+')
hold off
subplot(1,2,2)
imshow(watersh_im_log, []); 
hold on
scatter(centroid_list(:,1), centroid_list(:,2), 20,'+')
hold off