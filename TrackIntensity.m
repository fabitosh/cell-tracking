%% Test Params
% cellcore_image = imread('mask.gif');
% video = VideoReader('equal1.mp4'); 

% Let's go
cellcore_image = imread('08.01.2019_1_hTC_P268_p8_d5_+AA_S2__1.tif');
video = VideoReader('08.01.2019_1_hTC_P268_p8_d5_+AA_S2__2.avi'); 
[mask] = CreateMask(cellcore_image, true);
[frames] = TransformFrames(video, 120, 135); %start 120, end 210
[cellIntensities] = LogMaskIntensities(mask, frames)
VisualizeCellIntensities(cellIntensities)