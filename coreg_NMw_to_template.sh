#!/bin/sh
#Description: example script to coregister a neuromelanin-weighted image to the
#corresponding T1-w image and then to a study-specific brain template. The
#transformation computed using this procedure is then applied to manual
#segmentations of the substantia nigra, to compute a frequency/probability map
#of manually segmenting the visible substantia nigra in a group of subjects.
#Software: NiftyReg
#Author: Emma Biondetti
#E-mail: emma.biondetti@unich.it; emma.biondetti@gmail.com
#Date: 17/01/2021

#Defining brain template file
brain_template=average_nonlin_10.nii.gz

#Definining and creating output directories
outDir=Coregistrations_NMw_to_T1w
mkdir -p $outDir

outDir2=Coregistrations_T1w_to_SymmTemplate
mkdir -p $outDir2

outDir3=Coregistrations_NMw_to_SymmTemplate
mkdir -p $outDir3

#Defining reference images: T1-w original (NMw-to-T1w) and brain-extracted (T1w-to-template)
T1w_img=MPRAGE.nii.gz #image acquired using an MPRAGE sequence
brain_T1w_img=brain_MPRAGE.nii.gz

#Defining floating images: NM-w image and manual segmentations
NMw_img=TSE.nii.gz #image acquired using a TSE sequence
SN_ROI=SN_ROI_manual_segmentation.nii.gz

#Calculating and saving the rigid transformation from NMw to T1w
#Suggested tweak if registration fails: change -ln option to either 2 or 4
reg_aladin -flo $NMw_img -ref $T1w_img -aff $outDir/rT1_NMw_mat_rigid.txt -rigOnly

#Applying the rigid transformation to the NMw image to preserve the whole field of view
#This step is necessary for neuromelanin-sensitive turbo spin echo images, as
#these are usually acquired with a partial field of view along the foot-head
#direction
reg_resample -flo $NMw_img -ref $T1w_img -aff $outDir/rT1_NMw_mat_rigid.txt -res $outDir/rT1_NMw_rigid.nii.gz

#Because manual SN segmentations are binary, the nearest neighbour interpolation
#option is selected for applying the transformation to SN_ROI (-inter 0)
reg_resample -flo $SN_ROI -ref $T1w_img -aff $outDir/rT1_NMw_mat_rigid.txt -res $outDir/rT1_SN_ROI.nii.gz -inter 0

#Calculating the affine+nonlinear transformation from T1w to template
reg_aladin -flo $brain_T1w_img -ref $brain_template -aff $outDir2/rSymmTemplate_T1w_mat_affine.txt -res $outDir2/rSymmTemplate_T1w_affine.nii.gz
reg_f3d -flo $brain_T1w_img -ref $brain_template -aff $outDir2/rSymmTemplate_T1w_mat_affine.txt -res $outDir2/rSymmTemplate_T1w_nonlinear.nii.gz -cpp $outDir2/rSymmTemplate_T1w_cpp_nonlinear.nii.gz

#Applying the T1w-to-template transformation to the TSE image and the segmentations (in T1w space)
reg_resample -ref $brain_template -flo $outDir/rT1_NMw_rigid.nii.gz -cpp $outDir2/rSymmTemplate_T1w_cpp_nonlinear.nii.gz -res $outDir3/rSymmTemplate_rT1_NMw_nonlinear.nii.gz
reg_resample -ref $brain_template -flo $outDir/rT1_SN_ROI.nii.gz -cpp $outDir2/rSymmTemplate_T1w_cpp_nonlinear.nii.gz -res $outDir3/rSymmTemplate_rT1_SN_ROI.nii.gz -inter 0
