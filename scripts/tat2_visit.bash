#!/usr/bin/env bash
#SBATCH --time=1:15:00
#SBATCH --partition=RM-shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
# globals
#  REST_NUM        - default to 1 for rac1)
#  SUBJECT         - will use $1 if no SUBJECT
#  COMBO_NAME_ONLY - show output combinations, but dont run
#  DRYRUN          - show all tat2 commands, but dont run (will create fd censor file if DNE)
# 
export OUT_DIR=/ocean/projects/soc230004p/shared/datasets/tat2
export DATA_ROOT=/ocean/projects/soc230004p/shared/datasets/rest_preproc/pet
export PATH="$PATH:/ocean/projects/soc230004p/shared/tools/lncdtools:/ocean/projects/soc230004p/shared/tools/afni"

# COMBO_NAME_ONLY - externally set to show only combinations
#                   '| column -ts_' for a table fo all runs

FD_THRESH=0.3

# '_var-$var'
_name() {
  local var varval;
  var="$1"; varval="${!var}"
  if [ -z "$varval" ]; then
    case $var in
      inverse) varval=no;;
      calc) varval=default;;
      scale) varval=1000nvox;;
      # censor '' -> censor-none
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
    *1D)
	    [[ $varval =~ (fd-[0-9.]+).*.1D ]] &&
		    varval=${BASH_REMATCH[1]} ||
		    varval=$(basename $varval .1D);;
  esac
  echo "${var}${varval//[_-]/}";
}

mk_censor(){
  local file=$1 thres=$2
  awk -v thres=$thres '{print $1>=thres?0:1}' $file
}


run_subj(){
start_tic=$(date +%s)

# only care about subject when actually running
# dont generate files if just generating a list of output paramater combos
if [ -z "${COMBO_NAME_ONLY:-}" ] ; then

  # id is either from SUBJECT or the first input argument
  ld8=${SUBJECT:-$1} #10195_20160317

  # defualt to first run (petrest_rac1)
  # ./01_queue_tat2.bash will export REST_NUM=2 for petrest_rac2
  run_num=${REST_NUM:-1}

  outdir=$OUT_DIR/$ld8/pet$run_num

  # need bold and motion correction framewise displacement file
  input_bold=$DATA_ROOT/petrest_rac$run_num/brnsuwdktm_rest/$ld8/wudktm_func.nii.gz
  [ ! -r $input_bold ] && warn "# $ld8 missing bold input '$input_bold'" && exit 1
  fd_file=$(dirname "$input_bold")/motion_info/fd.txt
  [ ! -r "$fd_file" ] && warn "# $ld8 missing fd '$fd_file'" && exit 1

  # can make censor file if needed
  # NB alos update 'censor' in for loop if chaning FD_THRESH
  censor_fd=$(dirname "$fd_file")/censor_fd-$FD_THRESH.1D
  [ ! -r "$censor_fd" ] && warn "making $censor_fd" && mk_censor "$fd_file" $FD_THRESH > "$censor_fd"
fi

i=0
inverse="" # disabled b/c have 'calc_ln'

for ref in subject_mask.nii.gz; do
  for timeopt in  -median_time -mean_time; do
    for volopt in -median_vol -mean_vol; do
      #for inverse in '' -inverse; do
        for calc in '' -calc_zscore -calc_ln -no_vol; do
          for scale in '' -no_voxscale; do
            [[ -z "$scale" && ( $calc =~ (no_vol|calc_(zscore|ln)) || $volopt =~ median ) ]] && continue
	    for censor in "-censor_rel motion_info/censor_fd-$FD_THRESH.1D"; do
	      let ++i
	      # $(_name inverse)
	      name="$(_name ref)$(_name timeopt)$(_name volopt)$(_name censor)$(_name calc)$(_name scale)"
              [ -n "${COMBO_NAME_ONLY:-}" ] && echo "$name" && break
              output=$outdir/${name}_tat2.nii.gz
	      tic=$(date +%s)
              echo  "# [$(date +%F\ %H:%M.%S)] START:$i; $ld8 $name"
              [ -r "$output" ] && continue

	      dryrun mkdir -p $outdir
              dryrun tat2 $timeopt $volopt $inverse $calc $scale \
                -mask_rel "$ref" \
	        $censor \
                -output $output \
                -tmp ${LOCAL:-/tmp} \
                $input_bold
	      toc=$(date +%s)
	      echo "# [$(date +%F\ %H:%M.%S)] FINISH:$i; $(($toc-$tic)) secs; $ld8 $name"
	    done # cen
          done # scale
        done # calc
      # done # inv
    done # vol
  done # time
done # ref

stop_toc=$(date +%s)
echo "# [$(date +%F\ %H:%M.%S)] DONE; $(($stop_toc-$start_tic)) secs"
}

eval "$(iffmain run_subj)"
