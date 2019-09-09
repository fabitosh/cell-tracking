# cell-tracking
Takes an image with highlighted cells and a video as input. Computes all affine transformations between the video frames and recursively reverts them back onto the first frame. It then tracks the intensities of the detected cells over the course of the video. 

Developed and tested with MATLAB R2018b Student Version

## Requirements:
To import .tf8 Files: https://docs.openmicroscopy.org/bio-formats/5.7.0/developers/matlab-dev.html

## TrackIntensity.m
Main Executable. Adjust following variables:

### Inputs
* datapath: Where your experiments are stored. The folder should have two corresponding experiment files:
  * CellCore Image: ending with __1.tf8 
  * Video of the stretched cells: ending with __2.tf8
* Optionally downscale all images by setting the if condition on line 36 to true.
  * scaling_factor determines how much the images will be downscaled.
* videoname: Set Pre- and Suffixes according to your desire.
* csvname: Set Pre- and Suffixes according to your desire.

The script searches for all .tf8 files in datapath (ignoring content of subfolders). The alphabetically sorted .tf8 files are computed. It is assumed that corresponding experiment files are next to each other (e.g. the video is following the cellcore image). Ensure that there are no irrelevant .tf8 files in the path. 

### Outputs
For each experiment a video and a csv file are output:
* The video, generated through visualizePipeline.m, shows four frames to check the validity of the algorithms operations. 
  * Upper Left: Original video
  * Upper Right: Mask hovering over the cellcore image
  * Bottom Left: Video with reversed affine transformations
  * Bottom Right: Mask over the transformed video, which is used to track the cell intensities.
* A csv-file, containing the intensity of each cell over all frames
  * Columns are cells
  * Rows are video frames
  * Values are averaged intensities of each cell. __Important: Cells which can not be tracked over all frames due to the transformations, are also saved. Post-process all cells where the values drop to zero at any point.__

The algorithm is set up modularly. For adaptations, adjustment the parts to your experiemnt's need. 

