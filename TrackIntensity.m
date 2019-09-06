%Convert .tf8 to regular file formats
%Loop over folder

%% Load Raw Data
disp('********** Load Data **********'); tic;
experimentName = "08.01.2019_1_hTC_P268_p8_d5_+AA_S2";

% For tif and avi files
% experimentName = "p7d5S1";
% cellcore_image = imread(join([experimentName,'__1.tif'], ""));
% video = VideoReader(join([experimentName,'__2.avi'], "")); 
% frames = getFrames(video, 120, 210); %start 120, end 210

% Import tf8
path = "/Users/fabiomeier/Documents/MATLAB/CellTracking/datastack1/";
filepath = char(join([path, experimentName, '__1.tf8'], ''));
cellcore = bfopen(filepath);
cellcore_image = cellcore{1, 1}{1, 1};
filepath = char(join([path, experimentName, '__2.tf8'], ''));
tf8frames = bfopen(filepath);
tf8frames = tf8frames{1,1};
rowHeadings = {'img', 'info'};
frames = cell2struct(tf8frames, rowHeadings, 2);
% frames = frames(120:210);
clear rowHeadings
clear tf8frames
toc;

%% Downscale Images
disp('********** Downscale Images **********'); tic

scaling_factor = 0.2;
cellcore_image = imresize(cellcore_image, scaling_factor);
L = length(frames);
frames_ds = struct();
for ii = 1:L
    frames_ds(ii).img = imresize(frames(ii).img, scaling_factor);
end
frames = frames_ds;
clear frames_ds

toc;
%% Create Masks and get Frames
mask = createMask(cellcore_image, scaling_factor, false);
% Optional ToDo: Detect not-changing frames before action happens


%% Two Stage Affine Frame Transform
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.01;
optimizer.MaximumIterations = 100;
TF_reference = "PreviousFrame"; 
disp('********** Affine Transformations 1 **********')
[tfFrames1, tf1] = transformFrames(frames, optimizer, metric, TF_reference);


%% Save visualized result movie
videoname = char(join(['Check_',experimentName,'_test_fullRes'], ''));
visualizePipeline(frames, cellcore, mask, tfFrames1, videoname);


%% Compute and plot results
cellIntensities = logMaskIntensities(mask, tfFrames1);
visualizeCellIntensities(cellIntensities)