# Ventricle ROIS
## Source
Ventricle ROIs are derived from [CerebrA](https://gin.g-node.org/anamanera/CerebrA/)

|R  | L|
|---|---|
|41 = R vent    | 92 = L vent   |
|29 = R 3rd vent| 80 =L 3rd vent|
|37 = R 4th vent| 88 =L 4th vent|

voxel counts (1mm) for ventricle regions in original CerebrA atlas
```
3dROIstats -1DRformat -nomeanout -nzvoxels \
  -mask atlases/ref/CerebrA.nii.gz'<41,92,80,29,88,37>' \
   atlases/ref/CerebrA.nii.gz |\
 datamash transpose

name    atlases/ref/CerebrA.nii.gz_0[?]
NZcount_29      1100     # R 3rd
NZcount_37      772      # R 4th
NZcount_41      9570     # R vent
NZcount_80      613      # L 3rd
NZcount_88      612      # L 4th
NZcount_92      9570     # L vent
```

## 4th vs 3rd
The orig `vent` mask included the 4th instead of 3rd vent. 4th vent coverage in EPI acqustions is poor.
The updated `vent3` corrects this. [`atlases/Makefile`](atlases/Makefile) annotates how the atlases are created.

`vent` has `670` voxels in the mask (but EPI coverage would be less in any acquisition).

`vent3` has `654` total. They share `636` voxels (at the func resolution)



```
3dROIstats -nomeanout -nzvoxels \
  -mask atlases/ref/ventricles3_res-func.nii.gz \
  atlases/ref/ventricles_res-func.nii.gz \
  atlases/ref/ventricles3_res-func.nii.gz

File    Sub-brick       NZcount_1
atlases/ref/ventricles_res-func.nii.gz  0[#0]   636
atlases/ref/ventricles3_res-func.nii.gz 0[#0]   654

# ---- 

3dROIstats -nomeanout -nzvoxels \
  -mask atlases/ref/ventricles_res-func.nii.gz \
  atlases/ref/ventricles_res-func.nii.gz \
  atlases/ref/ventricles3_res-func.nii.gz

File    Sub-brick       NZcount_1
atlases/ref/ventricles_res-func.nii.gz  0[#0]   670
atlases/ref/ventricles3_res-func.nii.gz 0[#0]   636
```

