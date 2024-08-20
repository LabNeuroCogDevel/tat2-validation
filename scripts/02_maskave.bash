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
tat2_files=(../output/1*_2*/pet*/*_tat2.nii.gz)
echo "# running for ${#tat2_files[@]} tat2 files"
mkdir -p ../stats
echo "# nifti $(date)"
3dROIstats -nzvoxels -nzmean -nomeanout -nzsigma -mask "$roi_atlas" -1DRformat "${tat2_files[@]}" > ../stats/CaudPutPalAcc.tsv

echo "# json info $(date)"
echo -e 'filename\tvolume_norm_3dROIstats\ttime_norm_3dcalc\tnvox\t.concat_nvol\tnvolx_nocen\texpr' > ../stats/run_info.tsv
jq -r '[input_filename,.volume_norm_3dROIstats,.time_norm_3dcalc,.nvox[0], .concat_nvol,.nvolx_nocen,.expr]|@tsv' ${tat2_files[@]/.nii.gz/.log.json} >> ../stats/run_info.tsv
