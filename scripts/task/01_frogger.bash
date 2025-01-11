#!/usr/bin/env bash
#
# run tat2 on frogger for 
#
# 20241208WF - init
#
cd "$(dirname "$0")" || exit 1


[[ $# -eq 0 || "$*" =~ ^-+h ]] && echo "usage: $0 [all|/Volumes/Hera/preproc/pet_frog/MHTask_pet-18_09c/1*_2*|/Volumes/Phillips/mMR_PETDA/subjs/1*_2*/]" && exit 
[[ $1 == all ]] &&
  #SESDIRS=(/Volumes/Hera/preproc/pet_frog/MHTask_pet-18_09c/1*_2*) ||
  #SESDIRS=(/Volumes/Phillips/mMR_PETDA/subjs/1*_2*) ||
  SESDIRS=(/Volumes/Hera/preproc/pet_frog/MHTask_pet/1*_2*) ||
  SESDIRS=("$@")

echo "# $(date) running tat2 for ${#SESDIRS[@]} session dirs"

#mkdir -p tat2_w{,u}dktm
for sesdir in "${SESDIRS[@]}"; do 
   ld8=$(ld8 "$sesdir")
   # files like
   # /Volumes/Hera/preproc/pet_frog/MHTask_pet-18_09c/10195_20190321/1_seq16/wudktm_func.nii.gz
   # /Volumes/Phillips/mMR_PETDA/subjs/1*_2*/func/1/wdktm_func_1.nii.gz
   # censor like
   # /Volumes/Hera/preproc/pet_frog/MHTask_pet-18_09c/10195_20190321/1_seq16/motion_info/censor_custom_fd_0.3_dvars_Inf.1D
    
   #infiles=("$sesdir"/[0-9]_s*/wudktm_func.nii.gz)
   #
   # 20250111WF - also exclude rewarped to actual 18_09c (only 112 without these)
   #              otherwise we skip b/c too many infiles
   mapfile -t infiles < \
      <(find "$sesdir" -maxdepth 3 \
        -iname 'w*ktm_func*.nii.gz'  \
        -not -iname '*mask*' -not -name '*tmean*' -not -iname '*.18_09c.nii.gz' )

   [[ ${#infiles[@]} -le 1 || ${#infiles[@]} -gt 6 ]] &&
      warn "# ERROR $ld8: bad number of input files ${#infiles[*]} (expect 6 $sesdir/w*ktm_func*.nii.gz not mask nor tmean)" && continue

   # w/ and w/o field unwarping (ran wdktm w/o first, keeping around for now)
   case "${infiles[0]}" in 
      */wdktm*) outdir=tat2_wdktm ;;
      */wudktm*) outdir=tat2_wudktm ;;
      *) warn "#ERROR: ${infiles[0]} not wdktm or wudktm"; continue;;
   esac
   case "${infiles[0]}" in 
      */wdktm*) outdir=tat2_wdktm ;;
      */wudktm*) outdir=tat2_wudktm ;;
      *) warn "#ERROR: ${infiles[0]} not wdktm or wudktm"; continue;;
   esac

   outfile=$outdir/${ld8}_calc-ln_tat2.nii.gz
   [ -r "$outfile" ] && echo "# already have $outfile" && continue

   # make missing .3 fd file if missing
   cen_rel=motion_info/censor_custom_fd_0.3_dvars_Inf.1D
   for f in "${infiles[@]}"; do
      fd=$(dirname "$f")/motion_info/fd.txt
      cen=$(dirname "$f")/$cen_rel
      [ ! -r "$fd" ] && echo "ERROR $ld8: no fd file '$fd'" && continue 2
      [ ! -r "$cen" ] && awk '{print ($1>.3)?0:1}' "$fd" | drytee "$cen"
      :
   done

   dryrun tat2 \
      -median_time -median_vol -calc_ln -no_voxscale \
      -censor_rel "$cen_rel" \
      -mask_rel 's/\/w.*?_(.*).nii.gz/\/wktm_\1_98_2_mask_dil1x.nii.gz/' \
      -output "$outfile" "${infiles[@]}" &

   [ -n "${DRYRUN:-}" ] && sleep .2
   waitforjobs -j 15 -c "auto"
done

echo "# $(date) disbatched all! waiting for last jobs to finish"
wait
echo "# $(date) finished all"
