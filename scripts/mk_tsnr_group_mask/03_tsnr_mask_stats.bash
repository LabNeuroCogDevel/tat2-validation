#!/usr/bin/env bash
#
# voxel and volume count of snr maps
# 20250217WF - init
#

nohead=
for f in tsnr/rac*/1*_2*_thres-3_mask.nii.gz; do
   3dROIstats -1DRformat -nobriklab -nzvoxels -nzvolume -mask "$f" "${f/thres-3_mask/tsnr}" | sed "$nohead"
   # remove 3dROIstats header after first time it's printed
   [ -z "$nohead" ] && nohead=1d
done | tee tsnr/tsnr_idv_stats.tsv

for run in rac1 rac2; do
   3dROIstats \
      -1DRformat -nobriklab -nzvoxels -nzvolume \
      -mask ./tsnr/${run}_thres-3_coverage95bin.nii.gz \
      tsnr/${run}/1*_2*_thres-3_mask.nii.gz \
      > tsnr/${run}_maskcnt-idvInGrp.tsv
done
