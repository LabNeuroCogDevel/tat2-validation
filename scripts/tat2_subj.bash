#!/usr/bin/env bash
#SBATCH --time=0:30:00
#SBATCH --partition=RM-shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
export OUT_DIR=/ocean/projects/soc230004p/shared/datasets/tat2
export DATA_ROOT=/ocean/projects/soc230004p/shared/datasets/rest_preproc/pet
export PATH="$PATH:/ocean/projects/soc230004p/shared/lncdtools:/ocean/projects/soc230004p/shared/afni"

# COMBO_NAME_ONLY - externally set to show only combinations
#                   '| column -ts_' for a table fo all runs

# '_var-$var'
_name() {
  local var varval;
  var="$1"; varval="${!var}"
  if [ -z "$varval" ]; then
    case $var in
      inverse) varval=no;;
      calc) varval=default;;
      scale) varval=1000nvox;;
      *) varval=none;;
    esac
  fi
  var=_${var/opt/}-
  varval=$(perl -pe 's/(mean|median)_(time|vol)/$1/' <<< "${varval}")
  case $varval in
    *no_voxscale) varval=none;;
    *subject_mask*) varval=wholebrain;;
    *zscore*)  varval=zscore;;
    *calc_ln)  varval=log;;
    *inverse) varval=yes;;
  esac
  echo "${var}${varval//[_-]/}";
}

run_subj(){
ld8=${SUBJECT:-$1} #10195_20160317
outdir=$OUT_DIR/$ld8/pet1
mkdir -p $outdir
for ref in subject_mask.nii.gz; do
  for timeopt in  -median_time -mean_time; do
    for volopt in -median_vol -mean_vol; do
      for inverse in '' -inverse; do
        for calc in '' -calc_zscore -calc_ln -no_vol; do
          for scale in '' -no_voxscale; do
            [[ -z "$scale" && ( $calc =~ calc_(zscore|ln) || $volopt =~ median ) ]] && continue
            name="$(_name ref)$(_name timeopt)$(_name volopt)$(_name inverse)$(_name calc)$(_name scale)"
            output=$outdir/${name}_tat2.nii.gz 
            [ -n "${COMBO_NAME_ONLY:-}" ] && echo "$name" && break
            echo  "# [$(date)] $ld8 $name; time=$(date +%s)"
            [ -r "$output" ] && continue
            dryrun tat2 $timeopt $volopt $inverse $calc $scale \
              -mask_rel "$ref" \
              -output $output \
              -tmp ${LOCAL:-/tmp} \
              $DATA_ROOT/petrest_rac1/brnsuwdktm_rest/$ld8/wudktm_func.nii.gz
            echo "FINISH time=$(date +%s)"
          done
        done
      done
    done
  done
done
}

eval "$(iffmain run_subj)"
