#!/usr/bin/env bash
#
# voxel and volume count of snr maps
# 20250217WF - init
# 20250219WF - add second count (idv mask in grp mask)
#

nohead=
for ses_mask_gt3 in tsnr/rac*/1*_2*_thres-3_mask.nii.gz; do
   # use actual tsnr data as mask input. gives useful mean
   # otherwise could use roistats with mask=input but mean would always be 1
   # also, b/c mask tsnr>3 generated with same input, nzcounts will match (tsnr>3 also >0)
   ses_tsnr="${ses_mask_gt3/thres-3_mask/tsnr}"
   3dROIstats -1DRformat -nobriklab -nzvoxels -nzvolume \
      -mask "$ses_mask_gt3" "$ses_tsnr" |
      sed "$nohead"
   # remove 3dROIstats header after first time it's printed
   [ -z "$nohead" ] && nohead=1d
done | tee tsnr/tsnr_idv_stats.tsv

# also get stats for group mask
# how much overlap does each ses tsnr>3 mask have with the group @ 95% coverage
for run in rac1 rac2; do
   group_mask=./tsnr/${run}_thres-3_coverage95bin.nii.gz
   3dROIstats \
      -1DRformat -nobriklab -nzvoxels -nzvolume \
      -mask $group_mask \
      tsnr/${run}/1*_2*_thres-3_mask.nii.gz \
      > tsnr/${run}_maskcnt-idvInGrp.tsv
done
