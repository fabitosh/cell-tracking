%Convert .tf8 to regular file formats
%Loop over folder

%% Load Raw Data
experimentName = "08.01.2019_1_hTC_P268_p8_d5_+AA_S2";

% For tif and avi files
% experimentName = "p7d5S1";
% cellcore_image = imread(join([experimentName,'__1.tif'], ""));
video = VideoReader(join([experimentName,'__2.avi'], "")); 
frames_vid = getFrames(video, 120, 125); %start 120, end 210

% Import tf8
path = "/Users/fabiomeier/Documents/MATLAB/CellTracking/datastack1/";
filepath = char(join([path, experimentName, '__1.tf8'], ''));
cellcore = bfopen(filepath);
cellcore_image = cellcore{1, 1}{1, 1};
filepath = char(join([path, experimentName, '__2.tf8'], ''));
tf8frames = bfopen(filepath);
tf8frames = tf8frames{1,1};
rowHeadings = {'img', 'info'};
tf8frames = cell2struct(tf8frames, rowHeadings, 2);

%% Downscale Images
scaling_factor = 0.2;
cellcore_image = imresize(cellcore_image, scaling_factor);
L = length(tf8frames);
tf8frames_ds = struct();
for ii = 1:L
    tf8frames_ds(ii).img = imresize(tf8frames(ii).img, scaling_factor);
end
frames = tf8frames_ds(120:210);

%% Create Masks and get Frames
mask = createMask(cellcore_image, scaling_factor, false);
% Optional ToDo: Detect not-changing frames before action happens


%% Two Stage Affine Frame Transform
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.01;
optimizer.MaximumIterations = 100;
TF_reference = "PreviousFrame"; 
[tfFrames1, tf1] = transformFrames(frames, optimizer, metric, TF_reference);

[optimizer2, metric2] = imregconfig('monomodal');
optimizer2.MaximumStepLength = 0.01;
optimizer2.MaximumIterations = 100;
TF_reference = "FirstFrame";
[tfFrames2, tf2] = transformFrames(tfFrames1, optimizer2, metric2, TF_reference);

%% Save visualized result movie
visualizePipeline(frames, mask, tfFrames1, tfFrames2, char(join(['Check_',experimentName,'_Stage1_PrevFrame.avi'], '')));

%% Compute and plot results
cellIntensities = logMaskIntensities(mask, tfFrames2);
visualizeCellIntensities(cellIntensities)