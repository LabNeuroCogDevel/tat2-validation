#!/usr/bin/env bash
tsnr_mask(){
  tsnr_thres=3
  prefix=$1; shift
  out_mask=${prefix}_thres-${tsnr_thres}_mask.nii.gz
  out_tsnr=${prefix}_tsnr.nii.gz
  [ -r "$out_mask" ] && echo "# already have $out_mask" && return 0

  local tmpdir=""
  if [[ ! -r "$out_tsnr" ]]; then

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/tsnr_XXX")"
    [[ -z "$tmpdir" || ! -d "$tmpdir" ]] &&
       echo "# ERROR: tsnr tmpdir failed '$tmpdir'" &&
       return 1

    echo "# using $tmpdir"

    # only concat if more than one nifti
    if [ $# -gt 1 ]; then
       concat="$tmpdir/concat.nii.gz"
       3dTcat -prefix "$concat" "$@"
    else
       concat="$1"
    fi

    # tsnr with mean and std without detrending
    3dTstat             -prefix "$tmpdir/mean.nii.gz" "$concat"
    3dTstat -stdevNOD   -prefix "$tmpdir/stdev.nii.gz" "$concat"
    3dcalc  -expr 'm/s' -prefix "$out_tsnr" \
       -m "$tmpdir/mean.nii.gz" -s "$tmpdir/stdev.nii.gz"
  fi

  3dmask_tool -input "3dcalc( -t $out_tsnr -expr step(t-${tsnr_thres}) )" -fill_holes -prefix "$out_mask"

  # remove temporary files only when everything is as expected
  # KEEP_TEMPDIR also can block deletion
  [[ -z "${KEEP_TEMPDIR:-}" && -z "$tmpdir" && -d "$tmpdir" ]] &&
     rm -r "$tmpdir"
  return 0
}

# if not sourced (testing), run as command
eval "$(iffmain "tsnr_mask")"
