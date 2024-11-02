#!/usr/bin/env bash
# roi stats for r2prime using upsampled tat2 atlas
# 20241102 - init. partial of ../02_maskave.bash


r2pdt=/Volumes/Phillips/mMR_PETDA/scripts/r2pvox/r2primeMap_datatable.txt
[ ! -r $r2pdt ] && echo "missing r2prime datatable! file and images only on rhea" && exit 1

roi_atlas=../../atlases/atlas-VentCCCaudPutPalAcc_res-r2p.nii.gz
[ ! -r $roi_atlas ] && echo "cannot read roi_atlas: '$roi_atlas'" && exit 1

roi_labels=../../atlases/HarOx-thr50-CaudPutPalAcc_labels.tsv

mapfile -t mask_args < <(
 cat $roi_labels |
    while read idx roiname; do
	    # new line so mapfile can separate
            echo -e "-m\n${roiname/ /}=$roi_atlas<$idx>"
    done)

# make absolute paths -- original relative path in another script dir
cut -f 5 "$r2pdt" |
 sed -n 's:../../subjs/:/Volumes/Phillips/mMR_PETDA/subjs/:p' |
 xargs 3dmaskave_grp \
   -pattern '\d{5}_\d{8}' \
   -roistats -nomeanout,-nzmean,-nzvoxels,-nzsigma \
   -m ventricles=$roi_atlas'<1>' \
   -m CC=$roi_atlas'<2>' \
   "${mask_args[@]}" \
   -csv ../../stats/r2p_CaudPutPalAcc.csv --
