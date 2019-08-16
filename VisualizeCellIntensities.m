function [] = VisualizeCellIntensities(s)
    % Struct of shape: (blob, frame)
    for blob = 1:length(s)
        if [s(blob,:).Mean] > -5
            plot([s(blob,:).Mean], ':'); hold on
        end
    end
    frames = size(s, 2);
    means = zeros(frames, 1);
    for frame = 1 : size(s, 2)
        means(frame) = mean([s(:,frame).Mean]);
    end
    plot(means, '-r', 'LineWidth', 5)
end

