function [] = SaveTransformedVideo(frames)
    video = VideoWriter('TF_Movie.avi'); %create the video object
    open(video); %open the file for writing
    for ii=1:length(frames) %where N is the number of images
      writeVideo(video,frames(ii).img); %write the image to file
    end
    close(video); %close the file
end

