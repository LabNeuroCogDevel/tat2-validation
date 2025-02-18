#!/usr/bin/env bash
#
# rerun tat2 but with the group coverage mask
# _ref-wholebrain_time-median_vol-median_censor-fd0.3_calc-log_scale-none_tat2
# extracted from ../tat2_visit.bash
# 20250205WF - init
# :
#
cd "$(dirname "$0")" || exit 1
source ../tat2_visit.bash # get _name

ref=tsnr_mask
timeopt=-median_time
volopt=-median_vol
calc=-calc_ln
FD_THRESH=0.3; censor="-censor_rel motion_info/censor_fd-$FD_THRESH.1D"
inverse=
scale=-no_voxscale
for run in rac1 rac2 dtbz; do

   ref_file=$PWD/tsnr/${run}_thres-3_coverage95bin.nii.gz
   [ ! -r "$ref_file" ] && echo "# ERROR $run has no tsnr mask: '$ref_file'" && continue

   FILES=(/Volumes/Hera/preproc/"petrest_$run"/brnsuwdktm_rest/*/wudktm_func.nii.gz)
   echo "# $run for ${#FILES[@]} files"
   for input_bold in "${FILES[@]}"; do
     ld8=$(ld8 "$input_bold")
     [ -z "$ld8" ] && echo "no id in '$input_bold'" && continue

     # ../02_maskave.bash looks in '../output/1*_2*/pet*/'
     outdir=../output/$ld8/pet$run
     mkdir -p "$outdir"

     name="$(_name ref)$(_name timeopt)$(_name volopt)$(_name censor)$(_name calc)$(_name scale)"
     output=$outdir/${name}_tat2.nii.gz

     tic=$(date +%s)
     mk_censor_find_fd "$(dirname "$input_bold")/${censor/* /}"
     dryrun tat2 $timeopt $volopt $inverse $calc $scale \
        -mask_rel "$ref_file" \
        $censor \
        -output "$output" \
        "$input_bold"
     
     toc=$(date +%s)
     echo "# [$(date +%F\ %H:%M.%S)] FINISH:$i; $((toc-tic)) secs; $ld8 $name"
     break
   done
done
