function [transformed_frames, tf] = transformFrames(frames, ...
                                                    optimizer, metric, ...
                                                    tfReference)   
    %% Handle different inptus for tfReference
    if tfReference == "FirstFrame"
        ref = 1;
    end
    % No input: refer to first frame
    if ~exist('tfReference','var')
        ref = 1;
    end

    %% Find Affine Transformations between Frames
    tic;
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
    toc; 
        
    %% Transform imported Images
    tic;
    imgsize = size(frames(1).img);
    transformed_frames(1).img = frames(1).img;
%     pcl = struct('x', [], 'y', [], 'val', []);
    for ii = 2 : length(frames)
        if tfReference == "PreviousFrame"
            pcl = img2pcl(frames(ii).img);
            for jj = ii:-1:2
                pcl = pcl_2d_tf(pcl, tf(jj));
            end
            transformed_frames(ii).img = pcl2img(pcl, imgsize(1), imgsize(2));  
        % Otherwise all frames are transformed to the base frame
        % pcl.x, pcl.y, pcl.val
        else
            transformed_frames(ii).img = frames(ii).img;
            transformed_frames(ii).img = imwarp(...
                transformed_frames(ii).img, ...
                tf(ii), ...
                'OutputView',imref2d(size(frames(ii).img)));
        end
    end
    disp('TransformFrames: Stage 2 complete. Images transformed.'); 
    toc;
end

function tfout = combine_affine2d_tf(tf1, tf2)
    tfout = tf1;
    tfout.T(1:2,1:2) = tf1.T(1:2,1:2) * tf2.T(1:2,1:2); % Rotation
    tfout.T(3, 1:2) = tf1.T(3, 1:2) + tf1.T(3, 1:2); % Translation
end

function pcl = pcl_2d_tf(pclIn, tf)
    L = size(pclIn.val, 1);
    pcl = pclIn;
    pos_new = [pclIn.x, pclIn.y, ones(L, 1)] * tf.T;
    pcl.x = pos_new(:, 1);
    pcl.y = pos_new(:, 2);
end

