# tat2
tat2 paper scripts.
Intially, this directory links to other directorys on rhea.
As of 20240718, now includes PSC scripts as well

This code lives on briges/PSC
`/ocean/projects/soc230004p/shared/tat2-validation`

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

| ref        | time   |  vol   |censor |inverse|calc   |scale     |
| ---------- |------- |--------|-------|-----|---------| -------- |
| wholebrain | median | median | fd0.3 | no  | default | none     |
| wholebrain | median | median | fd0.3 | no  | zscore  | none     |
| wholebrain | median | median | fd0.3 | no  | log     | none     |
| wholebrain | median | median | fd0.3 | no  | novol   | none     |
| wholebrain | median | median | fd0.3 | yes | default | none     |
| wholebrain | median | median | fd0.3 | yes | zscore  | none     |
| wholebrain | median | median | fd0.3 | yes | log     | none     |
| wholebrain | median | median | fd0.3 | yes | novol   | none     |
| wholebrain | median | mean   | fd0.3 | no  | default | 1000nvox |
| wholebrain | median | mean   | fd0.3 | no  | default | none     |
| wholebrain | median | mean   | fd0.3 | no  | zscore  | none     |
| wholebrain | median | mean   | fd0.3 | no  | log     | none     |
| wholebrain | median | mean   | fd0.3 | no  | novol   | 1000nvox |
| wholebrain | median | mean   | fd0.3 | no  | novol   | none     |
| wholebrain | median | mean   | fd0.3 | yes | default | 1000nvox |
| wholebrain | median | mean   | fd0.3 | yes | default | none     |
| wholebrain | median | mean   | fd0.3 | yes | zscore  | none     |
| wholebrain | median | mean   | fd0.3 | yes | log     | none     |
| wholebrain | median | mean   | fd0.3 | yes | novol   | 1000nvox |
| wholebrain | median | mean   | fd0.3 | yes | novol   | none     |
| wholebrain | mean   | median | fd0.3 | no  | default | none     |
| wholebrain | mean   | median | fd0.3 | no  | zscore  | none     |
| wholebrain | mean   | median | fd0.3 | no  | log     | none     |
| wholebrain | mean   | median | fd0.3 | no  | novol   | none     |
| wholebrain | mean   | median | fd0.3 | yes | default | none     |
| wholebrain | mean   | median | fd0.3 | yes | zscore  | none     |
| wholebrain | mean   | median | fd0.3 | yes | log     | none     |
| wholebrain | mean   | median | fd0.3 | yes | novol   | none     |
| wholebrain | mean   | mean   | fd0.3 | no  | default | 1000nvox |
| wholebrain | mean   | mean   | fd0.3 | no  | default | none     |
| wholebrain | mean   | mean   | fd0.3 | no  | zscore  | none     |
| wholebrain | mean   | mean   | fd0.3 | no  | log     | none     |
| wholebrain | mean   | mean   | fd0.3 | no  | novol   | 1000nvox |
| wholebrain | mean   | mean   | fd0.3 | no  | novol   | none     |
| wholebrain | mean   | mean   | fd0.3 | yes | default | 1000nvox |
| wholebrain | mean   | mean   | fd0.3 | yes | default | none     |
| wholebrain | mean   | mean   | fd0.3 | yes | zscore  | none     |
| wholebrain | mean   | mean   | fd0.3 | yes | log     | none     |
| wholebrain | mean   | mean   | fd0.3 | yes | novol   | 1000nvox |
| wholebrain | mean   | mean   | fd0.3 | yes | novol   | none     |

# Log
20231219   - added atlas/ ->  `/Volumes/Hera/Projects/BTC_tat2validate/data/atlases`
20240718WF - init readme
