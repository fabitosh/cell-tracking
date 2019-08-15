function [] = VisualizePipeline(original_frames, transformed_frames, mask, name)
    %% Create and save video
    video = VideoWriter(name); %create the video object
    open(video); %open the file for writing
    for ii = 1:length(original_frames)
        tile = imtile({original_frames(ii).img, transformed_frames(ii).img, mask}, 'GridSize', [1 3]);
        writeVideo(video, tile); %write the image to file
    end
    close(video); %close the file
end

