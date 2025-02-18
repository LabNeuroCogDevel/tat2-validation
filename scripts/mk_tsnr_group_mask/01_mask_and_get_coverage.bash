#!/usr/bin/env bash
#
# 20250204WF - copy of HS prelim.process for PET study
#

# tsnr and threshold
# get id
sesid() { grep -Po '\d{5}_\d{8}' <<< "$*"; }

tsnr_mask_main() {
 for seq in rac1 rac2 dtbz; do
   outdir=tsnr/$seq/
   test -r "tsnr/${seq}_tsnr_mean.nii.gz" && echo "# have '$_'; rm to redo" && continue
   mkdir -p $outdir
   FILES=(/Volumes/Hera/preproc/petrest_$seq/brnsuwdktm_rest/*/wudktm_func.nii.gz)
   for f in "${FILES[@]}"; do 
     [[ !  -r $f ]] && echo "no file like '$f'" && continue
     sesid=$(sesid "$f" || :)
     [[ -z $sesid ]] && echo "no id in '$f'" && continue
     # make $outdir/${sesid}_thres-3_mask.nii.gz
     dryrun ./tsnr_mask.bash "$outdir/${sesid}" "$f"
   done

   ## summary files
   # coverage mask based on .95%
   dryrun 3dMean -prefix tsnr/${seq}_thres-3_coverage.nii.gz      -overwrite\
      tsnr/${seq}/*_thres-3_mask.nii.gz
   dryrun 3dcalc -prefix tsnr/${seq}_thres-3_coverage95bin.nii.gz -overwrite \
      -expr 'step(a-.95)' -a tsnr/${seq}_thres-3_coverage.nii.gz
   # tsnr mean
   dryrun 3dMean -non_zero -prefix tsnr/${seq}_tsnr_mean.nii.gz  -overwrite $outdir/*_tsnr.nii.gz
 done

}

# if not sourced (testing), run as command
eval "$(iffmain "tsnr_mask_main")"
