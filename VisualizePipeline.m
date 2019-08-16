function [] = VisualizePipeline(original_frames, mask, transformed_frames, transformed_frames2, name)
    tic;
    %% Create and save video
    video = VideoWriter(name); %create the video object
    open(video); %open the file for writing
    for ii = 1:length(original_frames)
        tile = imtile({original_frames(ii).img, mask, transformed_frames(ii).img, transformed_frames2(ii).img}, 'GridSize', [2 2]);
        writeVideo(video, tile); %write the image to file
    end
    close(video); %close the file
    disp('Video saved');
    toc;
end