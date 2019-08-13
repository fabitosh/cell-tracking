%Import Strain-corrected stack of images (cum_reg_stack)
load('F:\tobi\ImStack_StrainCorrected_Frame120-210_08.01.2019_1_hTC_P268_p8_d5_+AA_S2__2.mat')
% diff_im_stack = diff(cum_reg_stack, 1, 3);
% diff_im_stack_3 = cum_reg_stack(:,:,4:end) - cum_reg_stack(:,:,1:end-3);
hblob = vision.BlobAnalysis( ...
                'AreaOutputPort', false, ...
                'BoundingBoxOutputPort', false, ...
                'OutputDataType', 'single', ...
                'MinimumBlobArea', 200, ...
                'MaximumBlobArea', inf, ...
                'MaximumCount', 1500, ...
                'Connectivity', 4);
% %Replace all zero-pixels with NaN (Out of view pixels)
cum_reg_stack = double(cum_reg_stack);
% cum_reg_stack(cum_reg_stack == 0) = NaN;
% %Standardize entire stack (to keep relative intensity changes)
% cum_reg_stack_norm = normalize(cum_reg_stack);

for iframe = 1 : size(cum_reg_stack, 3)
    curr_im = cum_reg_stack(:,:,iframe);
    subplot(1,2,1)
    imshow(curr_im, []);  
    %Rescale intensities to interval [0, 1]
    curr_im = (curr_im - min(curr_im(:))) / (max(curr_im(:)) - min(curr_im(:)));
%     %Maximize image contrast using histogram equalization
%     curr_im = histeq(curr_im);
%     %Increase cell-to-cell contrast
%     curr_im = 4 * curr_im - imdilate(curr_im, strel([2 1 2; 2 1 2; 2 1 2]));    
%     curr_im(curr_im<0) = 0;
%     curr_im(curr_im>1) = 1;
%     curr_im = imdilate(curr_im, strel('disk', 1)) - curr_im;
    %Determine threshold using Otsu's method   
    curr_thresh = multithresh(curr_im, 2)
    %Binarize the image 
    curr_im = (curr_im >= 1.1 * curr_thresh(end));
    centroid_list{iframe} = hblob(curr_im);   % Calculate the centroid
    numBlobs(iframe) = size(centroid_list{iframe},1);  % and number of cells.
    p2 = subplot(1,2,2)
    imshow(curr_im, []);
    hold on
    scatter(centroid_list{iframe}(:,1), centroid_list{iframe}(:,2), 20,'+')
    hold off
    pause
end