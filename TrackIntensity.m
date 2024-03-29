%% Loop over experiment folder
% Ensure that only __1.tf8 and corresponding __2.tf8 files are in datapath.
% Important to have two _ before the final number (e.g. x__1.tf8 and not x_1.tf8)
datapath = '/Volumes/FabioWD/++CellTracking/data/';
files = dir(strcat(datapath,'*.tf8'));
L = length(files);

for ii = 1:2:L
    %% Get corresponding Experiment Pair out of Dataset
    str = split(files(ii).name, "__");
    str2 = split(files(ii+1).name, "__");
    experimentName = str(1);
    if ~strcmp(str(1), str2(1))
        disp('Experiment names ii and ii+1 do not match. Aborting')
        ii
        files(ii).name
        files(ii+1).name
        return
    end
    
    %% Load Raw Data
    disp('********** Load Data **********'); tic; % Import tf8
    path = "/Users/fabiomeier/Documents/MATLAB/CellTracking/datastack1/";
    filepath = char(join([datapath, experimentName, '__1.tf8'], ''));
    cellcore = bfopen(filepath);
    cellcore_img = cellcore{1, 1}{1, 1};
    filepath = char(join([datapath, experimentName, '__2.tf8'], ''));
    tf8frames = bfopen(filepath);
    tf8frames = tf8frames{1,1};
    rowHeadings = {'img', 'info'};
    frames = cell2struct(tf8frames, rowHeadings, 2);
    % frames = frames(120:210);
    clear rowHeadings; clear tf8frames; toc;

    %% Downscale Images
    if false % if downscalign is desired, set to true. 
        disp('********** Downscale Images **********'); tic
        scaling_factor = 0.1; % Adaptable Parameter 
        cellcore_img = imresize(cellcore_img, scaling_factor);
        L = length(frames);
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
    videoname = char(join(['Check_',experimentName,'.avi'], ''));
    visualizePipeline(frames, cellcore_img_scaled, mask, tfFrames1, videoname);

    %% Compute and plot results
    [cellIntensities, meanArray] = logMaskIntensities(mask, tfFrames1);
    csvname = char(join(['CellIntensities_',experimentName,'.csv'], ''));
    % Rows: Frames, Cols: Cell ID, Values: Averaged Intensity in Blob
    csvwrite(csvname, meanArray); 
%     visualizeCellIntensities(cellIntensities)
end