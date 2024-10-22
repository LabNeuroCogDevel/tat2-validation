#!/usr/bin/env bash
#SBATCH --time=4:30:00
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

roi_atlas=../atlases/atlas-VentCCCaudPutPalAcc_res-func.nii.gz
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
# this is too slow! takes over 2h 30min to run on only half the ROIs!
# didn't profile, but suspect roistats per file and grep check are bottlenecks
#find ../output/1*_2*/pet*/ -iname '*_tat2.nii.gz' |
#  3dmaskave_grp \
#     -stdinfiles \
#     -roistats -nomeanout,-nzmean,-nzvoxels,-nzsigma \
#     -pattern '\d{5}_\d{8}/pet[12]' \
#     -m ventricles=$roi_atlas'<1>' \
#     -m CC=$roi_atlas'<2>' \
#     "${mask_args[@]}" \
#     -csv ../stats/CaudPutPalAcc.csv

# 3dmaskave_grp has nice output, but this is faster

find ../output/1*_2*/pet*/ -maxdepth 1 -iname '*_tat2.nii.gz' | xargs \
 3dROIstats -nzvoxels -nzmean -nomeanout -nzsigma -mask "$roi_atlas" -1DRformat  > ../stats/atlas-roistats.tsv

echo "# json info $(date)"
echo -e 'filename\tvolume_norm_3dROIstats\ttime_norm_3dcalc\tnvox\t.concat_nvol\tnvolx_nocen\texpr' > ../stats/run_info.tsv
find ../output/1*_2*/pet*/ -maxdepth 1 -iname '*_tat2.log.json' |
  xargs jq -r \
    '[input_filename,.volume_norm_3dROIstats,.time_norm_3dcalc,.nvox[0], .concat_nvol,.nvolx_nocen,.expr]|@tsv' \
    >> ../stats/run_info.tsv

echo "# finished $(date)"
