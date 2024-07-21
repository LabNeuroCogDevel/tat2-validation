#!/usr/bin/env bash
# copy files needed for tat2 (minproc warped rest, motion, mask)
#
# 20240718WF - init
for rnum in 1 2; do
 rsync -L -azvhi \
   /Volumes/Hera/preproc/petrest_rac$rnum/brnsuwdktm_rest \
   bridges2:/ocean/projects/soc230004p/shared/datasets/rest_preproc/pet/petrest_rac$rnum/ \
   `#--dry-run` \
   --size-only \
   --exclude '*DS_Store' \
   --include '*/*/motion_info/' \
   --include '*/*/motion_info/fd.txt' \
   --exclude '*/*/*/*' \
   --include '*/*/motion.par' \
   `# --include '*/*/subject_mask.nii.gz'` \
   --include '*/*/wudktm_func.nii.gz' \
   --include '*/*/wktm_func_98_2_mask_dil1x_templateTrim.nii.gz' \
   --exclude '*/*/*'
done

# alt
# find /Volumes/Hera/preproc/petrest_rac1/brnsuwdktm_rest  -iname wudktm_func.nii.gz |sed s:/Volumes/Hera/preproc/petrest_rac1/brnsuwdktm_rest/: | rsync --files-from -
