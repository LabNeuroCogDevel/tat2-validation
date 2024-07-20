# tat2
tat2 paper scripts.
Intially, this directory links to other directorys on rhea.
As of 20240718, now includes PSC scripts as well

This code lives on briges/PSC
`/ocean/projects/soc230004p/shared/tat2-validation`

## Permutations
from `COMBO_NAME_ONLY=1 scripts/tat2_subj.bash x|column -ts_ >> readme.md`

| ref            | time       |  vol      |inverse     |calc        |scale       |
| -------------- |----------- |---------- |----------  |------------| ---------- |
| ref-wholebrain |time-median |vol-median |inverse-no  |calc-default| scale-none |
| ref-wholebrain |time-median |vol-median |inverse-no  |calc-zscore | scale-none |
| ref-wholebrain |time-median |vol-median |inverse-no  |calc-log    | scale-none |
| ref-wholebrain |time-median |vol-median |inverse-no  |calc-novol  | scale-none |
| ref-wholebrain |time-median |vol-median |inverse-yes |calc-default| scale-none |
| ref-wholebrain |time-median |vol-median |inverse-yes |calc-zscore | scale-none |
| ref-wholebrain |time-median |vol-median |inverse-yes |calc-log    | scale-none |
| ref-wholebrain |time-median |vol-median |inverse-yes |calc-novol  | scale-none |
| ref-wholebrain |time-median |vol-mean   |inverse-no  |calc-default| scale-1000nvox |
| ref-wholebrain |time-median |vol-mean   |inverse-no  |calc-zscore | scale-none |
| ref-wholebrain |time-median |vol-mean   |inverse-no  |calc-log    | scale-none |
| ref-wholebrain |time-median |vol-mean   |inverse-no  |calc-novol  | scale-1000nvox |
| ref-wholebrain |time-median |vol-mean   |inverse-yes |calc-default| scale-1000nvox |
| ref-wholebrain |time-median |vol-mean   |inverse-yes |calc-zscore | scale-none |
| ref-wholebrain |time-median |vol-mean   |inverse-yes |calc-log    | scale-none |
| ref-wholebrain |time-median |vol-mean   |inverse-yes |calc-novol  | scale-1000nvox |
| ref-wholebrain |time-mean   |vol-median |inverse-no  |calc-default| scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-no  |calc-zscore | scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-no  |calc-log    | scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-no  |calc-novol  | scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-yes |calc-default| scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-yes |calc-zscore | scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-yes |calc-log    | scale-none |
| ref-wholebrain |time-mean   |vol-median |inverse-yes |calc-novol  | scale-none |
| ref-wholebrain |time-mean   |vol-mean   |inverse-no  |calc-default| scale-1000nvox |
| ref-wholebrain |time-mean   |vol-mean   |inverse-no  |calc-zscore | scale-none |
| ref-wholebrain |time-mean   |vol-mean   |inverse-no  |calc-log    | scale-none |
| ref-wholebrain |time-mean   |vol-mean   |inverse-no  |calc-novol  | scale-1000nvox |
| ref-wholebrain |time-mean   |vol-mean   |inverse-yes |calc-default| scale-1000nvox |
| ref-wholebrain |time-mean   |vol-mean   |inverse-yes |calc-zscore | scale-none |
| ref-wholebrain |time-mean   |vol-mean   |inverse-yes |calc-log    | scale-none |
| ref-wholebrain |time-mean   |vol-mean   |inverse-yes |calc-novol  | scale-1000nvox |


# Log
20231219   - added atlas/ ->  `/Volumes/Hera/Projects/BTC_tat2validate/data/atlases`
20240718WF - init readme
