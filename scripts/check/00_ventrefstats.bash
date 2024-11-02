#!/usr/bin/env bash
# ventrical atlas roi stats per 4D rest image
# 20240926WF - init
# 20241022WF - move into own folder
cd "$(dirname "$0")" || exit 1
echo "$(date) finding files"
FILES=(/Volumes/Hera/preproc/petrest_rac*/brnsuwdktm_rest/1*_2*/wudktm_func.nii.gz)
for atlas in '../../atlases/ref/ventricles_res-func.nii.gz' '../../atlases/ref/CerebrA_res-func.nii.gz<41,92,80,29,88,37>'; do
  case "$atlas" in 
     *ventricles*)
        prefix=vent
        stats="mean NZMean_1 max NZSigma_1 mean NZcount_1 min Min_1 max Max_1";;
     *CerebrA*)
        prefix=eachvent;
        stats=$(for i in 41 92 80 29 88 37; do
           echo "mean NZMean_$i max NZSigma_$i mean NZcount_$i min Min_$i max Max_$i"; done
           );;
     *) echo "ERROR: unknown atlas '$atlas'"; continue;;
  esac

  summary_out="../check/${prefix}_summary.tsv"
  [ -r "$summary_out" ] && echo "# already have $summary_out; rm to redo" && continue

  echo "$(date) generating stats of '$atlas' for ${#FILES[@]} 4D images inot $summary_out"
  # shellcheck disable=SC2068 # want $stats to be split
  time 3dROIstats -1DRformat -mask "$atlas" \
     -nomeanout -minmax -nzmean -nzsigma -nzvoxels\
    "${FILES[@]}" |
     tee "../check/${prefix}_roistats.tsv" |
     sed -E 's/ *//g;s/.nii.gz_[^\t]*//'  |
     datamash -H groupby name ${stats[@]} |
     tee "$summary_out" 

  echo "$(date) finished generating stats: $(wc -l "$summary_out") rows"
done
