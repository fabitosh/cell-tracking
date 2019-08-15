function [] = VisualizeCellIntensities(s)
    % Struct of shape: (blob, frame)
    for blob = 1:length(s)
        plot([s(blob,:).Mean]); hold on
    end
end

