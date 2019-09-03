%Convert .tf8 to regular file formats
%Loop over folder

%% Load Raw Data
experimentName = "08.01.2019_1_hTC_P268_p8_d5_+AA_S2_ds";
% experimentName = "p7d5S1";
cellcore_image = imread(join([experimentName,'__1.tif'], ""));
video = VideoReader(join([experimentName,'__2.avi'], "")); 

%% Create Masks and get Frames
mask = createMask(cellcore_image, true);
% Optional ToDo: Detect not-changing frames before action happens
frames = getFrames(video); %start 120, end 210

%% Two Stage Affine Frame Transform
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.01;
optimizer.MaximumIterations = 100;
TF_reference = "PreviousFrame"; 
[tfFrames1, tf1] = transformFrames(frames, optimizer, metric, TF_reference);

[optimizer2, metric2] = imregconfig('monomodal');
optimizer2.MaximumStepLength = 0.01;
optimizer2.MaximumIterations = 10;
TF_reference = "FirstFrame";
[tfFrames2, tf2] = transformFrames(tfFrames1, optimizer2, metric2, TF_reference);

%% Save visualized result movie
visualizePipeline(frames, mask, tfFrames1, tfFrames2, char(join(['Check_',experimentName,'_Stage1_PrevFrame.avi'], '')));

%% Compute and plot results
cellIntensities = logMaskIntensities(mask, tfFrames2);
visualizeCellIntensities(cellIntensities)