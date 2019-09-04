function visualizePipeline(original_frames, mask, transformed_frames, transformed_frames2, name)
    tic;
    %% Create and save video
    video = VideoWriter(name); %create the video object
    open(video); %open the file for writing
    for ii = 1:length(original_frames)
        
        originalimg = original_frames(ii).img;
        tf1img = transformed_frames(ii).img;
        tf2img = transformed_frames2(ii).img;
        maskedtf2 = labeloverlay(transformed_frames2(ii).img, mask);
        
        multi = cat(3, originalimg, tf1img, tf2img, maskedtf2);
        tile = montage(multi);
        
        %Add the tile to video
        writeVideo(video, tile); 
    end
    close(video); %close the file
    disp('Video saved');
    toc;
end
