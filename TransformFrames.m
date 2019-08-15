function [transformed_frames] = TransformFrames(video, start_frame, end_frame)
    tic;
    %% Load Video as frames
    if ~exist('start_frame','var')
      start_frame = 0;
    end
    if ~exist('end_frame','var')
      end_frame = 0; % later logic requires it to be set to 0
    end
    frame_count = 0;
    curr_count = 0;
    while hasFrame(video)
        frame_count = frame_count + 1;
        readFrame(video);
        if frame_count >= start_frame && ((frame_count <= end_frame) || (end_frame == 0))
            curr_count = curr_count + 1;
%             frame_stack(:,:,curr_count) = rgb2gray(readFrame(video));
            frame_stack(:,:,curr_count) = readFrame(video);
        elseif frame_count > end_frame
            break
        end
    end
    disp('TransformFrames: Stage 1 complete. Frames Loaded')
    toc; tic;
    
    %% Find Affine Transformations between Frames
    [optimizer, metric] = imregconfig('monomodal');
    optimizer.MaximumStepLength = 0.01;
    optimizer.MaximumIterations = 100;

    for iframe = 1 : size(frame_stack, 3)-1
        tform_stack(iframe) = imregtform(...
            frame_stack(:,:,iframe), ...
            frame_stack(:,:,iframe + 1), ...
            'affine', optimizer, metric);
    end
    disp('TransformFrames: Stage 2 complete. Affine Transformations between Frames found')
    toc; tic;
    
    %% Transform imported Images
    for iframe = 1 : size(frame_stack, 3)
        i_addframe = iframe;
        while i_addframe < size(frame_stack, 3)
            transformed_frames(iframe).img = imwarp(...
                frame_stack(:,:,iframe), ...
                tform_stack(i_addframe), ...
                'OutputView',imref2d(size(frame_stack(:,:,iframe + 1))));
            i_addframe = i_addframe + 1;
        end
    end
    disp('TransformFrames: Stage 3 complete. Images transformed.')
    toc;
%     for iframe = 1 : size(transformed_frames)
%         subplot(1,2,1)
%         imshow(frame_stack(:,:,iframe), []);
%         subplot(1,2,2)
%         imshow(transformed_frames(iframe).img, []);
    %     imshowpair(frame_stack(:,:,iframe), cum_reg_stack(:,:,iframe));
%     end
end
