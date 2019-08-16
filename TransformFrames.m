function [transformed_frames, tf] = TransformFrames(frames, optimizer, metric, tfReference)   
    tic;
    %% Handle different inptus for tfReference
    if tfReference == "FirstFrame"
        ref = 1;
    end
    if ~exist('tfReference','var')
        ref = 1;
    end

    %% Find Affine Transformations between Frames
    for ii = 1 : length(frames)-1
        if tfReference == "PreviousFrame"
            ref = ii;
        end
        tf(ii) = imregtform(...
            frames(ii+1).img, ...
                frames(ref).img, ...
            'affine', optimizer, metric);
    end
    disp('TransformFrames: Stage 1 complete. Affine Transformations between Frames found')
    toc; tic;
    
    %% Transform imported Images
    transformed_frames = frames;
    for ii = 1 : length(frames)-1
        if tfReference == "PreviousFrame" % Loop recursively over all TF's
            for jj = 2 : ii % Loop over all Transformations together
                transformed_frames(ii+1).img = imwarp(...
                    transformed_frames(ii+1).img, ...
                    tf(jj), ...
                    'OutputView',imref2d(size(frames(ii).img)));
            end
        end
        if ref == 1 % Only transform once. 
            transformed_frames(ii+1).img = imwarp(...
                transformed_frames(ii+1).img, ...
                tf(ii), ...
                'OutputView',imref2d(size(frames(ii).img)));
        end
    end
    disp('TransformFrames: Stage 2 complete. Images transformed.')
    toc;
end
