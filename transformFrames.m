function [transformed_frames, tf] = transformFrames(frames, ...
                                                    optimizer, metric, ...
                                                    tfReference)   
    %% Handle different inptus for tfReference
    tic;
    if tfReference == "FirstFrame"
        ref = 1;
    end
    % No input: refer to first frame
    if ~exist('tfReference','var')
        ref = 1;
    end

    %% Find Affine Transformations between Frames
    for ii = 2 : length(frames)
        if tfReference == "PreviousFrame"
            ref = ii-1;
        end
        tf(ii) = imregtform(...
            frames(ii).img, ...
            frames(ref).img, ...
            'affine', optimizer, metric);
    end
    disp('TransformFrames: Stage 1 complete.') 
    disp('Affine Transformations between Frames found.')
    toc; tic;
    
    save('TempWS.mat')
    
    %% Transform imported Images
    load('TempWS.mat')
    imgsize = size(frames(1).img);
%     pcl = struct('x', [], 'y', [], 'val', []);
    for ii = 2 : length(frames)
        if tfReference == "PreviousFrame"
            pcl = img2pcl(frames(ii).img);
            for jj = ii:-1:2
                pcl = pcl_2d_tf(pcl, tf(jj));
            end
            transformed_frames(ii).img = pcl2img(pcl.x, pcl.y, pcl.val, ...
                                                 imgsize(1), imgsize(2));  
        % Otherwise all frames are transformed to the base frame
        else
            transformed_frames(ii).img = frames(ii).img;
            transformed_frames(ii).img = imwarp(...
                transformed_frames(ii).img, ...
                tf(ii), ...
                'OutputView',imref2d(size(frames(ii).img)));
        end
    end
    disp('TransformFrames: Stage 2 complete. Images transformed.')
    toc;
end

function tfout = combine_affine2d_tf(tf1, tf2)
    tfout = tf1;
    tfout.T(1:2,1:2) = tf1.T(1:2,1:2) * tf2.T(1:2,1:2); % Rotation
    tfout.T(3, 1:2) = tf1.T(3, 1:2) + tf1.T(3, 1:2); % Translation
end

function pcl = pcl_2d_tf(pclIn, tf)
    L = size(pclIn.val);
    pcl = pclIn;
    for ii = 1:L
        pos_new = [pclIn.x(ii), pclIn.y(ii), 1] * tf.T;
        pcl(ii).x = pos_new(1);
        pcl(ii).y = pos_new(2);
    end
end

function I = pcl2img(x,y,z,numr,numc )
% By: Vahid Behravan
% This function converts a point cloud (given in x,y,z) to a gray scale image
% We assume the ToF camera is alligned with 'x-axis' 
%
% x,y,z: coordinate vectors of all points in the cloud
% numr: desired number of rows of output image
% numc: desired number of columns of output image
% I   : output gray scale image
%
% Example useage:
%   I = pointcloud2image( x,y,z,250,250 );
%   figure;  imshow(I,[]);
%
%------ Revision History -----------------------------------
%    ver 1.0: first release.
%    ver 1.2: normalize pixel values to [0,1] (Jan. 2016)
%-----------------------------------------------------------
% depth calculation
d = sqrt( x.^2 + y.^2 + z.^2);
% grid construction
yl = min(y); yr = max(y); zl = min(z); zr = max(z);
yy = linspace(yl,yr,numc); zz = linspace(zl,zr,numr);
[Y,Z] = meshgrid(yy,zz);
grid_centers = [Y(:),Z(:)];
% classification
clss = knnsearch(grid_centers,[y,z]); 
% defintion of local statistic
local_stat = @(x)mean(x);
%local_stat = @(x)min(x); 
% data_grouping
class_stat = accumarray(clss,d,[numr*numc 1],local_stat);
% 2D reshaping
class_stat_M  = reshape(class_stat , size(Y)); 
% Force un-filled cells to the brightest color
class_stat_M (class_stat_M == 0) = max(max(class_stat_M));
% flip image horizontally and vertically
I = class_stat_M(end:-1:1,end:-1:1);
% normalize pixel values to [0,1]
I = ( I - min(min(I)) ) ./ ( max(max(I)) - min(min(I)) );
end

