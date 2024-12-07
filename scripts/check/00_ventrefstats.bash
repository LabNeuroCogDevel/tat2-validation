#!/usr/bin/env bash
# ventrical atlas roi stats per 4D rest image
# 20240926WF - init
# 20241022WF - move into own folder
cd "$(dirname "$0")" || exit 1
echo "$(date) finding files"
FILES=(/Volumes/Hera/preproc/petrest_rac*/brnsuwdktm_rest/1*_2*/wudktm_func.nii.gz)
crbrvent=(41 92 80 29 88 37)
IFS=, crbrvent_csv="${crbrvent[*]}";
mkstats_cmd(){
   local i=${1:?roi index value}
   echo -n "mean NZMean_$i max NZSigma_$i mean NZcount_$i min Min_$i max Max_$i "
}

for atlas in\
   '../../atlases/ref/ventricles_res-func.nii.gz'\
   "../../atlases/ref/CerebrA_res-func.nii.gz<$crbrvent_csv>"; do
  case "$atlas" in 
     *ventricles*) prefix=vent;     roi_idxes=(1);;
     *CerebrA*)    prefix=eachvent; roi_idxes=("${crbrvent[@]}");;
     *) echo "ERROR: unknown atlas '$atlas'"; continue;;
  esac

  mapfile -d' ' -t stats < <(for i in "${roi_idxes[@]}"; do mkstats_cmd "$i"; done)
  rawstats_out="../check/${prefix}_roistats.tsv"
  summary_out="../check/${prefix}_summary.tsv"

  echo -e "$(date) generating stats of '$atlas' for ${#FILES[@]} 4D images into $summary_out"
  [ -r "$summary_out" ] && echo "# already have $summary_out; rm to redo" && continue
  [ -n "${DRYRUN:-}" ] && echo "# dryrun, not running" && continue

  # shellcheck disable=SC2068 # want $stats to be split
  time 3dROIstats -1DRformat -mask "$atlas" \
     -nomeanout -minmax -nzmean -nzsigma -nzvoxels\
    "${FILES[@]}" |
     tee "$rawstats_out" |
     sed -E 's/ *//g;s/.nii.gz_[^\t]*//'  |
     datamash -H groupby name ${stats[@]} |
     tee "$summary_out" 

  echo "$(date) finished generating stats: $(wc -l "$summary_out") rows"
done
