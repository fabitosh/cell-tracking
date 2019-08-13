V = VideoReader('08.01.2019_1_hTC_P268_p8_d5_+AA_S2__2.avi'); 
start_frame = 120;
end_frame = 210;
frame_count = 0;
curr_count = 0;
while hasFrame(V)
    frame_count = frame_count + 1
    readFrame(V);
    if frame_count >= start_frame & frame_count <= end_frame
        curr_count = curr_count + 1;
        frame_stack(:,:,curr_count) = readFrame(V);
    elseif frame_count > end_frame
        break
    end
end

[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.01;
optimizer.MaximumIterations = 100;

for iframe = 1 : size(frame_stack, 3)-1
    tform_stack(iframe) = imregtform(...
        frame_stack(:,:,iframe), ...
        frame_stack(:,:,iframe + 1), ...
        'affine', optimizer, metric);
    reg_stack(:,:,iframe) = imwarp(...
        frame_stack(:,:,iframe), ...
        tform_stack(iframe), ...
        'OutputView',imref2d(size(frame_stack(:,:,iframe + 1))));
    iframe
end
for iframe = 1 : size(frame_stack, 3)
    i_addframe = iframe;
    cum_reg_stack(:,:,iframe) = frame_stack(:,:,iframe);
    while i_addframe < size(frame_stack, 3)
        cum_reg_stack(:,:,iframe) = imwarp(...
            cum_reg_stack(:,:,iframe), ...
            tform_stack(i_addframe), ...
            'OutputView',imref2d(size(frame_stack(:,:,iframe + 1))));
        i_addframe = i_addframe + 1;
    end
end

for iframe = 1 : size(cum_reg_stack, 3)
    subplot(1,2,1)
    imshow(frame_stack(:,:,iframe), []);
    subplot(1,2,2)
    imshow(cum_reg_stack(:,:,iframe), []);
    imshowpair(frame_stack(:,:,iframe), cum_reg_stack(:,:,iframe));
end
