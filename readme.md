# T2* Validation
Running many parameter permutations of [`tat2`](https://github.com/lncd/lncdtools/blob/master/tat2) [![DOI](https://zenodo.org/badge/152143120.svg)](https://zenodo.org/badge/latestdoi/152143120)

ROI means for tat2 parameter permutations are in [`stats/CaudPutPalAccVentCC.csv`](stats/CaudPutPalAccVentCC.csv)


Initially, this directory links to other directories on rhea.
As of 20240718, now includes PSC scripts as well.

This code lives on briges/PSC
`/ocean/projects/soc230004p/shared/tat2-validation`
and on rhea
`/Volumes/Hera/Projects/tat2`

## Data quality
`rhea` specific scripts in
[`scripts/check/`](scripts/check) calculates metrics to assess warp quality across the dataset
  * across subject MNI tmean-to-tmean warps as a measure of alignment quality are in [`scripts/check/all_nii/bad_alignments.csv`](scripts/check/all_nii/bad_alignments.csv) from [`scripts/check/all_nii/all_meants_enorm.1D`](scripts/check/all_nii/all_meants_enorm.1D)
  * per session ventricle tmean ROI stats are in [`scripts/check/vent_summary_zscored.tsv`](scripts/check/vent_summary_zscored.tsv)


## Permutations
### Inspecting

`tat2` saves a `.log.json` file along side the nifiti image. This may be easier to parse than the `3dNotes` embeded in the image file.

```
jq -r '[(input_filename|split("_")|.[7]), .expr]|@tsv' \
   data/10195_20160317/pet1/_ref-wholebrain_time-median_vol-median_censor-fd0.3_inverse-no_calc-*json|
   sort -u

calc-default    (x/m)*1
calc-log        -1*log(x/m)*1
calc-novol      (x/m)*m*1
calc-zscore     (x-m)/s*1
```


```
3dNotes_each -f \
 data/10195_20160317/pet1/_ref-wholebrain_time-median_vol-median_censor-fd0.3_inverse-no_calc-*nii.gz|
 perl -lne 'print "$1\t$2" if m/(calc-[a-z]+).*expr ([^ ]*)/'
calc-default    '(x/m)*1'
calc-log        '-1*log(x/m)*1'
calc-novol      '(x/m)*m*1'
calc-zscore     '(x-m)/s*1'
```

### Enumerated
from 
```
COMBO_NAME_ONLY=1 scripts/tat2_visit.bash |
  tr '_' '\t'|
  sed 's/^\t//;s/\t[a-z]*-/\t/g'|
  pandoc -f tsv -t gfm -
```

| ref        | time   |  vol   |censor |calc     |scale     |
| ---------- |------- |--------|-------|---------| -------- |
| wholebrain | median | median | fd0.3 | default | none     |
| wholebrain | median | median | fd0.3 | zscore  | none     |
| wholebrain | median | median | fd0.3 | log     | none     |
| wholebrain | median | median | fd0.3 | novol   | none     |
| wholebrain | median | mean   | fd0.3 | default | 1000nvox |
| wholebrain | median | mean   | fd0.3 | default | none     |
| wholebrain | median | mean   | fd0.3 | zscore  | none     |
| wholebrain | median | mean   | fd0.3 | log     | none     |
| wholebrain | median | mean   | fd0.3 | novol   | none     |
| wholebrain | mean   | median | fd0.3 | default | none     |
| wholebrain | mean   | median | fd0.3 | zscore  | none     |
| wholebrain | mean   | median | fd0.3 | log     | none     |
| wholebrain | mean   | median | fd0.3 | novol   | none     |
| wholebrain | mean   | mean   | fd0.3 | default | 1000nvox |
| wholebrain | mean   | mean   | fd0.3 | default | none     |
| wholebrain | mean   | mean   | fd0.3 | zscore  | none     |
| wholebrain | mean   | mean   | fd0.3 | log     | none     |
| wholebrain | mean   | mean   | fd0.3 | novol   | none     |

# Log
20231219   - added atlas/ ->  `/Volumes/Hera/Projects/BTC_tat2validate/data/atlases`
20240718WF - init readme
