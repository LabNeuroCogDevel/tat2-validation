#!/usr/bin/env bash
#
# run roi stats on tsnr grp mask tat2 3D images
#
# 20250220WF - init, partail copy of ../02_maskave.bash
#

roi_atlas=../../atlases/atlas-VentCCCaudPutPalAcc_res-func.nii.gz
[ ! -r $roi_atlas ] && echo "cannot read roi_atlas: '$roi_atlas'" && exit 1

# from 02_tat2_grpmask.bash
# files like ../output/10195_20160317/petrac1/_ref-tsnrmask_time-median_vol-median_censor-fd0.3_calc-log_scale-none_tat2.nii.gz
find ../output/ -type f,l -iname '_ref-tsnrmask*_tat2.nii.gz'  -print0  |
   xargs -0 \
    3dROIstats -nzvoxels -nzmean -nomeanout -nzsigma -mask "$roi_atlas" -1DRformat \
    > atlas-roistats.tsv
