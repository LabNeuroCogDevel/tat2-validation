# COMBO_NAME_ONLY=1 ./tat2_subj.bash | column -ts_
mkdir -p log
jobname=tat2-10195_20160317-rac1
logfile=log/%x_%A_%j.txt
squeue -o %j | grep $jobname && echo "# $jobname in queue, skipping" && exit #continue
sbatch \
      -J $jobname \
      -o $logfile -e $logfile \
      --export "BOLD_FILE=$bold" \
      tat2_subj.bash 10195_20160317
