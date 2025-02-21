#!/usr/bin/env bash
#
# like 01_roistats.bash but for all mni images
#   r2Map_mni_fast_al.nii.gz r2primeMap_mni_fast_al.nii.gz r2sMap_mni_fast_al.nii.gz
#
# using 3dROIstats (instead of slower 3dmaskave_grp)
# also see ../mk_tsnr_group_mask/03_tat2_roistats.bash
#
# 20250220WF - init

roi_atlas="../../atlases/atlas-VentCCCaudPutPalAcc_res-r2p.nii.gz"
[ ! -r $roi_atlas ] && echo "cannot read roi_atlas: '$roi_atlas'" && exit 1

# remote filesystem failing to resolve symlinks. some older r2p were run without proc/ dir
# newer are symlinked from proc (but not resolving on skynet mount)
# list both
find /Volumes/Phillips/mMR_PETDA/subjs/1*_2*/r2prime/proc/r2*_mni_*.nii.gz\
     /Volumes/Phillips/mMR_PETDA/subjs/1*_2*/r2prime/r2*MNI*_al.nii.gz\
     -print0 | xargs -0 \
  time 3dROIstats \
   -nomeanout -nzmean -nzvoxels -nzsigma -1DRformat -nobriklab \
   -mask "$roi_atlas" |
   sed 's:^/.*subj/::' \
   > ../../stats/r2-x3_atlas-VentCCCaudPutPalAcc_roistats.tsv
