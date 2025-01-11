roi_atlas="../../atlases/atlas-VentCCCaudPutPalAcc_res-func.nii.gz"
3dROIstats -nzvoxels -nzmean -nomeanout -nzsigma -mask "$roi_atlas" -1DRformat tat2_wudktm/*tat2.nii.gz > VentCCCaudPutPalAcc_roistats.txt
