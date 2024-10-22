#!/usr/bin/env bash
# compute tmean for ABCD. hallquist pipeline included this but fmprep does not
# 20241011 - init
# 20241022 - move script
ABCD_MNI=/Volumes/Hera/Datasets/ABCD/TAT2/mni/derivatives/abcd-hcp-pipeline/
find $ABCD_MNI -type f -iname '*rest*space-MNI_bold.nii.gz' |
   head -n 100 |
   parallel -j 25 'test -r /Volumes/Hera/scratch/abcd/tmean-{/} || 3dTstat -mean -prefix $_ {}'

# total ABCD rest is 3Tb!  tmean is a lot smaller 
# du -k  /Volumes/Hera/scratch/abcd/mean-sub-NDARINV0A4P0LWM_ses-baselineYear1Arm1_task-rest_run-2_space-MNI_bold.nii.gz /Volumes/Hera/Datasets/ABCD/TAT2/mni/derivatives/abcd-hcp-pipeline/sub-NDARINV0A4P0LWM/ses-baselineYear1Arm1/func/sub-NDARINV0A4P0LWM_ses-baselineYear1Arm1_task-rest_run-2_space-MNI_bold.nii.gz
# 872
# 332400
