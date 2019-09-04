function visualizePipeline(original_frames, mask, transformed_frames1, transformed_frames2, name)
    tic;
    %% Preprocessing
    % Convert images to doubles
    original_frames = double_imagestack(original_frames);
    transformed_frames1 = double_imagestack(transformed_frames1);
    transformed_frames2 = double_imagestack(transformed_frames2);
    % Find Scaling Factors
    [min, max] = get_intensitiy_extrema(original_frames); 
    
    %% Create and save video
    video = VideoWriter(name);
    open(video);
    for ii = 1:length(original_frames)        
        % Create tile out of base images
        original = intensity_normalization(original_frames(ii).img, min, max);
        tf1img = intensity_normalization(transformed_frames1(ii).img, min, max);
        tf2img = intensity_normalization(transformed_frames2(ii).img, min, max);
        maskoverlay = labeloverlay(tf2img, mask, 'Colormap', [0,1,0.2],'Transparency',0.6);
        tile = imtile({original , maskoverlay,  tf1img, tf2img}, 'GridSize', [2 2]);
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