#!/usr/bin/env bash
#
# submit jobs (tat2_visit.bash) for each visit and rac1+rac2
# use DRYRUN=1 ./01_queue_tat2.bash

# to see all combinations, look at ../readme.md or
#  COMBO_NAME_ONLY=1 ./tat2_subj.bash | column -ts_


cd "$(dirname "$0")"
source ../../setup_path.sh
mkdir -p log

for rest in 1 2; do
  visit_dirs=(/ocean/projects/soc230004p/shared/datasets/rest_preproc/pet/petrest_rac$rest/brnsuwdktm_rest/1*_2*/)
  for input in ${visit_dirs[@]}; do
    ld8=$(ld8 $input)
    jobname=tat2-$ld8-$rest
    logfile=log/%x_%A_%j.txt
    final_out="/ocean/projects/soc230004p/shared/datasets/tat2/$ld8/pet$rest/_ref-vent_time-median_vol-median_censor-fd0.3_calc-zscore_scale-none_tat2.nii.gz"
    test -r "$final_out"  && echo "# skip $jobname have '$_'" && continue
    squeue --me -o %j | grep $jobname && echo "# skip $jobname is in queue" && continue
    echo "# submit $jobname"
    dryrun sbatch \
          -J $jobname \
          -o $logfile -e $logfile \
          --export REST_NUM=$rest \
          tat2_visit.bash $ld8
  done
done
