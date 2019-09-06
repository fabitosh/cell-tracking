%Convert .tf8 to regular file formats
%Loop over folder

%% Load Raw Data
disp('********** Load Data **********'); tic; % Import tf8
path = "/Users/fabiomeier/Documents/MATLAB/CellTracking/datastack1/";
experimentName = "08.01.2019_1_hTC_P268_p8_d5_+AA_S2";
filepath = char(join([path, experimentName, '__1.tf8'], ''));
cellcore = bfopen(filepath);
cellcore_img = cellcore{1, 1}{1, 1};
filepath = char(join([path, experimentName, '__2.tf8'], ''));
tf8frames = bfopen(filepath);
tf8frames = tf8frames{1,1};
rowHeadings = {'img', 'info'};
frames = cell2struct(tf8frames, rowHeadings, 2);
% frames = frames(120:210);
clear rowHeadings; clear tf8frames; toc;

%% Downscale Images
if true 
    disp('********** Downscale Images **********'); tic
    scaling_factor = 0.5; % Adaptable Parameter 
    cellcore_img = imresize(cellcore_img, scaling_factor);
    L = length(frames);
    frames = struct();
    for ii = 1:L
        frames(ii).img = imresize(frames(ii).img, scaling_factor);
    end
    toc;
end
%% Create Mask
[mask, cellcore_img_scaled] = createMask(cellcore_img, scaling_factor, false);

%% Find Affine Transformations between frames and revert frames to base frame
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.01;
optimizer.MaximumIterations = 100;
TF_reference = "PreviousFrame"; 
disp('********** Affine Transformations **********')
[tfFrames1, tf1] = transformFrames(frames, optimizer, metric, TF_reference);

%% Save visualized result movie
videoname = char(join(['Check_',experimentName,'_outnew'], ''));
visualizePipeline(frames, cellcore_img_scaled, mask, tfFrames1, videoname);

%% Compute and plot results
[cellIntensities, meanArray] = logMaskIntensities(mask, tfFrames1);
csvname = char(join(['CellIntensities_',experimentName,'.csv'], ''));
csvwrite(csvname, meanArray); 
% Rows: Frames, Cols: Blobs, Values: Averaged Intensity in Blob

visualizeCellIntensities(cellIntensities)