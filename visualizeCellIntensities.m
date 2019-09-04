function visualizeCellIntensities(s)
    % Struct s of shape: (blob, frame_id)
    
    %% Plot intensity per blob over all frames
    for blob = 1:length(s)
        if [s(blob,:).Mean] > -5
            plot([s(blob,:).Mean], ':'); hold on
        end
    end
    
    %% Plot the mean of all blobs
    nr_frames = size(s, 2);
    means = zeros(nr_frames, 1);
    for frame = 1:size(s, 2)
        means(frame) = mean([s(:,frame).Mean]);
    end
    plot(means, '-r', 'LineWidth', 5)
end

