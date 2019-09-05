function [transformed_frames, tf] = transformFrames(frames, ...
                                                    optimizer, metric, ...
                                                    tfReference)   
    %% Handle different inptus for tfReference
    tic;
    if tfReference == "FirstFrame"
        ref = 1;
    end
    % No input: refer to first frame
    if ~exist('tfReference','var')
        ref = 1;
    end

    %% Find Affine Transformations between Frames
    for ii = 2 : length(frames)
        if tfReference == "PreviousFrame"
            ref = ii-1;
        end
        tf(ii) = imregtform(...
            frames(ii).img, ...
            frames(ref).img, ...
            'affine', optimizer, metric);
    end
    disp('TransformFrames: Stage 1 complete.') 
    disp('Affine Transformations between Frames found.')
    toc; tic;
    
    %% Transform imported Images
    transformed_frames = frames;
    
    for ii = 2 : length(frames)
        if tfReference == "PreviousFrame"
            tftemp = tf(1);
            for jj = ii:-1:2
                tftemp = combine_affine2d_tf(tftemp, tf(jj));
            end
            transformed_frames(ii).img = imwarp(...
                transformed_frames(ii).img, ...
                tftemp, ...
                'OutputView',imref2d(size(frames(ii).img)));
        % Otherwise all frames are transformed to the base frame
        else
            transformed_frames(ii).img = imwarp(...
                transformed_frames(ii).img, ...
                tf(ii), ...
                'OutputView',imref2d(size(frames(ii).img)));
        end
    end
    disp('TransformFrames: Stage 2 complete. Images transformed.')
    toc;
end

function tfout = combine_affine2d_tf(tf1, tf2)
    tfout = tf1;
    tfout.T(1:2,1:2) = tf1.T(1:2,1:2) * tf2.T(1:2,1:2); % Rotation
    tfout.T(3, 1:2) = tf1.T(3, 1:2) + tf1.T(3, 1:2); % Translation
end
