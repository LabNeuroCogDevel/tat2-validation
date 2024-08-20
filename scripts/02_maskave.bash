#!/usr/bin/env bash
#SBATCH --time=0:30:00
#SBATCH --partition=RM-shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

# run like
#  sbatch -J summary -o log/%x_%A_%j.txt 02_maskave.bash
#  always remakes ../stats/: CaudPutPalAcc.tsv run_info.tsv
set -euo pipefail

# start in this scripts directory. and maybe setup PSC
if test -d /jet/home/foranw/finn/shared/tat2-validation/scripts; then
  cd "$_" 
  source ../../setup_path.sh
else
  cd "$(dirname "$0")"
fi

roi_atlas=../atlases/HarOx-thr50-CaudPutPalAcc_res-func.nii.gz
[ ! -r $roi_atlas ] && echo "cannot read roi_atlas: '$roi_atlas'" && exit 1

# use lables to build up command arguments like
# -m LeftCaudate=atlas.nii.gz<5>
mapfile -t mask_args < <(
 cat ../atlases/HarOx-thr50-CaudPutPalAcc_labels.tsv|
    while read idx roiname; do
	    # new line so mapfile can separate
            echo -e "-m\n${roiname/ /}=$roi_atlas<$idx>"
    done)


echo "# nifti $(date)"
mkdir -p ../stats
find ../output/1*_2*/pet*/ -iname '*_tat2.nii.gz' |
  3dmaskave_grp \
     -stdinfiles \
     -roistats -nomeanout,-nzmean,-nzvoxels,-nzsigma \
     "${mask_args[@]}" \
     -csv ../stats/CaudPutPalAcc.tsv

# 3dmaskave_grp has nice output, but this is faster
#3dROIstats -nzvoxels -nzmean -nomeanout -nzsigma -mask "$roi_atlas" -1DRformat "${tat2_files[@]}" > ../stats/roistats

echo "# json info $(date)"
echo -e 'filename\tvolume_norm_3dROIstats\ttime_norm_3dcalc\tnvox\t.concat_nvol\tnvolx_nocen\texpr' > ../stats/run_info.tsv
find ../output/1*_2*/pet*/ -iname '*_tat2.log.json' |
  xargs jq -r \
    '[input_filename,.volume_norm_3dROIstats,.time_norm_3dcalc,.nvox[0], .concat_nvol,.nvolx_nocen,.expr]|@tsv' \
    >> ../stats/run_info.tsv

echo "# finished $(date)"
