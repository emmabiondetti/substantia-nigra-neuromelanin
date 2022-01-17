% Script for calculating the average neuromelanin signal-to-noise ratio in
% template space
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

% Loading the background (BND) and substantia nigra (SN) ROIs in template space
nii = load_nii([main_path 'SN_ROI_symmetric_three_subdivisions.nii.gz']);
SN_mask = double(nii.img);
n_voxel_SN = length(SN_mask(SN_mask == 1));
ss = size(SN_mask);
orig = nii.hdr.hist.originator(1:3);

% Loading background mask
nii = load_nii([main_path 'BND_ROI.nii.gz']);
BND_mask = double(nii.img);

% These lines isolate the associative (==1), limbic (==2) and sensorimotor
% (==3) parts of the SN mask, creating three separate binary masks
% (==1 in the corresponding subregion of the SN and ==0 everywhere else)
SN_mask_associative = SN_mask;
SN_mask_associative(SN_mask ~= 1) = 0;

SN_mask_limbic = SN_mask;
SN_mask_limbic(SN_mask ~= 2) = 0;
SN_mask_limbic(SN_mask_limbic == 2) = 1;

SN_mask_sensorimotor = SN_mask;
SN_mask_sensorimotor(SN_mask ~= 3) = 0;
SN_mask_sensorimotor(SN_mask_sensorimotor == 3) = 1;

% Defining IDs of subjects in the group of interest
subject_id = {'subject_01'; 'subject_02'; 'subject_03'};

% Preallocating variables where to save the SNR values
SNR_SN_mean = zeros(length(subject_id),1);
SNR_SN_limbic_mean = zeros(length(subject_id),1);
SNR_SN_associative_mean = zeros(length(subject_id),1);
SNR_SN_sensorimotor_mean = zeros(length(subject_id),1);

for i = 1:length(subject_id)
    % Loading the neuromelanin-sensitive image aligned with the template
    nii = load_nii([main_path subject_id{i} ...
        'Coregistrations_NMw_to_SymmTemplate/rSymmTemplate_rT1_NMw_nonlin.nii.gz']);
    rSymmTemplate_NMw = double(nii.img);

    % Calculating the average signal in the background ROI (ie,
    % applyinh the mask for the background ROI to the NM-sensitive image)
    BND_SN_mean = mean(rSymmTemplate_NMw(BND_mask == 1));

    % Calculating the neuromelanin SNR in the three functional subregions
    SNR_SN_limbic_mean(i,1) = ...
        mean(rSymmTemplate_NMw(SN_mask_limbic == 1))*100 / BND_SN_mean;
    SNR_SN_associative_mean(i,1) = ...
        mean(rSymmTemplate_NMw(SN_mask_associative == 1))*100 / BND_SN_mean;
    SNR_SN_sensorimotor_mean(i,1) = ...
        mean(rSymmTemplate_NMw(SN_mask_sensorimotor == 1))*100 / BND_SN_mean;
end
