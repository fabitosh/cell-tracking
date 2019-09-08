# cell-tracking

## Requirements:
To import .tf8 Files: https://docs.openmicroscopy.org/bio-formats/5.7.0/developers/matlab-dev.html
Developed and tested with MATLAB R2018b

## TrackIntensity.m
Main Executable. Adjust following variables:
* datapath: Where your experiments are stored. The folder should have two corresponding experiment files:
  * CellCore Image: ending with __1.tf8 
  * Video of the stretched cells: ending with __2.tf8
* Optionally downscale all images by setting the if condition on line 36 to true.
  * scaling_factor determines how much the images will be downscaled.
* videoname: Set Pre- and Suffixes according to your desire.
* csvname: Set Pre- and Suffixes according to your desire.

The script searches for all .tf8 files in datapath (ignoring content of subfolders). The alphabetically sorted .tf8 files are computed. It is assumed that corresponding experiment files are follw
