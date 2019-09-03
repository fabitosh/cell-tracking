function [frames] = getFrames(video, start_frame, end_frame)
    tic;
    %% Load Video as frames
    if ~exist('start_frame','var')
      start_frame = 0;
    end
    if ~exist('end_frame','var')
      end_frame = 0; % later logic requires it to be set to 0
    end
    curr_count = 0;
    nr_frames = video.NumberOfFrames;
    frames = [];
    for frame_nr = 1:nr_frames
        if frame_nr >= start_frame && ((frame_nr <= end_frame) || (end_frame == 0))
            curr_count = curr_count + 1;
            frames(curr_count).img = read(video, frame_nr);
        elseif frame_nr > end_frame
            break
        end
    end
    disp('GetFrames: Complete. Frames Loaded')
    toc; tic;
end

