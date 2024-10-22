#!/usr/bin/env bash
# ventrical atlas roi stats per 4D rest image
# 20240926WF - init
# 20241022WF - move into own folder
cd "$(dirname "$0")" || exit 1
date "$(date) finding files"
FILES=(/Volumes/Hera/preproc/petrest_rac*/brnsuwdktm_rest/1*_2*/wudktm_func.nii.gz)
echo "$(date) generating stats for ${#FILES[@]} 4D images"
time 3dROIstats -1DRformat -mask ../../atlases/ref/ventricles_res-func.nii.gz \
   -nomeanout -minmax -nzmean -nzsigma -nzvoxels\
  "${FILES[@]}" |
   tee ../check/vent_roistats.tsv |
   sed -E 's/ *//g;s/.nii.gz_[^\t]*//'  |
   datamash -H groupby name mean NZMean_1 max NZSigma_1 mean NZcount_1 min Min_1  max Max_1 |
   tee ../check/vent_summary.tsv
echo "$(date) finished generating stats: $(wc -l ../check/vent_summary.tsv) rows"
