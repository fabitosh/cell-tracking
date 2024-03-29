function visualizePipeline(original_frames, cellcore_img, mask, transformed_frames1, name)
    tic;
    %% Preprocessing
    % Convert images to doubles
    original_frames = double_imagestack(original_frames);
    transformed_frames1 = double_imagestack(transformed_frames1);
    % Find Scaling Factors
    [mini, maxi] = get_intensitiy_extrema(original_frames); 
    
    %% Create and save video
    video = VideoWriter(name);
    open(video);
    cellcore_img = labeloverlay(cellcore_img, mask, 'Colormap', [0,0.5,0.5],'Transparency',0.6);
    for ii = 1:length(original_frames)        
        % Create tile out of base images
        original = intensity_normalization(original_frames(ii).img, mini, maxi);
        tf1img = intensity_normalization(transformed_frames1(ii).img, mini, maxi);
        maskoverlay = labeloverlay(tf1img, mask, 'Colormap', [0,1,0.2],'Transparency',0.6);
        tile = imtile({original, cellcore_img, tf1img, maskoverlay}, 'GridSize', [2 2]);
        % Append tile frame to the video
        writeVideo(video, tile);
    end
    close(video);
    disp('********** Video saved **********');
    toc;
end

function imgs = double_imagestack(imgs)
    for ii = 1:length(imgs) 
        imgs(ii).img = double(imgs(ii).img);
    end
end

function [mini, maxi] = get_intensitiy_extrema(imgs)
    mini = 0;
    maxi = 0;
    for ii = 1:length(imgs) 
        if min(imgs(ii).img, [], 'all') < mini
            mini = min(imgs(ii).img, [], 'all');
        end
        if max(imgs(ii).img, [], 'all') > maxi
            maxi = max(imgs(ii).img, [], 'all');
        end
    end
end

function img = intensity_normalization(img, mini, maxi)
    img = (img - mini) / (maxi - mini);
end