# Substantia-nigra-neuromelanin
Collection of example code and files used for analysing neuromelanin-sensitive images acquired using magnetic resonance imaging (MRI)

## Publications
Biondetti, E., Gaurav, R., Yahia-Cherif, L., Mangone, G., Pyatigorskaya, N., Valabrègue, R., Ewenczyk, C., Hutchison, M., François, C., Corvol, J.C., Vidailhet, M., Lehéricy, S., 2020. Spatiotemporal changes in substantia nigra neuromelanin content in Parkinson’s disease. Brain 143, 2757–2770. https://doi.org/10.1093/brain/awaa216

Biondetti, E., Santin, M.D., Valabrègue, R., Mangone, G., Gaurav, R., Pyatigorskaya, N., Hutchison, M., Yahia-Cherif, L., Villain, N., Habert, M.-O., Arnulf, I., Leu-Semenescu, S., Dodet, P., Vila, M., Corvol, J.-C., Vidailhet, M., Lehéricy, S., 2021. The spatiotemporal changes in dopamine, neuromelanin and iron characterizing Parkinson’s disease. Brain 144, 3114–3125. https://doi.org/10.1093/brain/awab191

# Getting started

## Prerequisites
For each subject:
1. a neuromelanin-sensitive image of the substantia nigra (here, this was acquired using a TSE (turbo spin echo) sequence)
2. a structural T1-weighted image of the whole head (here, this was acquired using an MPRAGE (magnetisation prepared rapid gradient echo) sequence)
3. (optional) if interested in probability map calculation, a manual segmentation of the substantia nigra drawn on image 1

## Files
<b>average_nonlin_10.nii.gz</b>: brain template

<b>SN_ROI_symmetric_three_subdivisions.nii.gz</b>: symmetric substantia nigra region of interest subdivided into three functional territories (associative=1, limbic=2, and sensorimotor=3)

<b>BND_ROI.nii.gz</b>: background region of interest (in template space)

## Code
<b>coreg_NMw_to_template.sh</b>: example code, written for NiftyReg software (https://github.com/KCL-BMEIS/niftyreg), for aligning the neuromelanin-sensitive image and (optional) manual segmentation of the substantia nigra with template space

<b>SN_probability_map_calculation.m</b>: example code, written for MATLAB, for calculating a parametric map with the probability of segmenting the substantia nigra in a group of subjects (in template space)

<b>SNR_calculation_example.m</b>: example code, written for MATLAB, for calculating neuromelanin signal-to-noise ratios (SNRs) in the three functional subregions of the substantia nigra (in template space)
