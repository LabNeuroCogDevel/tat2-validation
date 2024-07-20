# tat2
tat2 paper scripts.
Intially, this directory links to other directorys on rhea.
As of 20240718, now includes PSC scripts as well

This code lives on briges/PSC
`/ocean/projects/soc230004p/shared/tat2-validation`

## Permutations
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
