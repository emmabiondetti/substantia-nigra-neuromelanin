% Script for calculating the SN probability map
% @AUTHOR: Emma Biondetti
% @EMAIL: emma.biondetti@unich.it; emma.biondetti@gmail.com
% @DATE: 17/01/2021
% @DEPENDENCIES: NifTI_20140122 Toolbox
% (https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image)

clear; close all; clc

% Adding toolbox files
addpath('/home/emma.biondetti/MATLAB/NifTI_20140122')

% Defining main data path
main_path = '/home/emma.biondetti/data/';

matrix_size = [176 232 256]; % template matrix size

% Defining IDs of subjects in the group of interest
subject_id = {'subject_01'; 'subject_02'; 'subject_03'};

% Loading individual SN segmentation in template space
all_SN_ROIs = zeros([matrix_size(1) matrix_size(2) matrix_size(3) length(subject_id)]);
for i = 1:length(subject_id)
    SN_dir = dir([main_path subject_id{i} ...
      '/Coregistrations_NMw_to_SymmTemplate/rSymmTemplate_rT1_SN_ROI.nii.gz']);
    SN_nii = load_nii([SN_dir.folder '/' SN_dir.name]);
    all_SN_ROIs(:,:,:,i) = double(SN_nii.img);
end

% Calculating probability map as the average segmentation
SN_probability_map = mean(all_SN_ROIs,4);

% Saving probability map
voxel_size = [1 1 1];
origin = SN_nii.hdr.hist.originator(1:3);
SN_probability_map_nii = ...
    make_nii(SN_probability_map, voxel_size, origin);
save_nii(SN_probability_map_nii, [main_path '/SN_probability_map.nii.gz'])
