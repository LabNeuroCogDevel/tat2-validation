#!/usr/bin/env Rscript
# 20241029 copied from ../03_parseROIstats.R -- todo refactor and remove dup code?

## load packages. install first if missing
if(!'pacman' %in% installed.packages()) install.packages('pacman')
suppressPackageStartupMessages({
  library(pacman)
  p_load(dplyr)
  p_load('tidyr')
  p_load('readr')
})

## read data
roistats <- read_tsv('VentCCCaudPutPalAcc_roistats.txt', show_col_types = FALSE)
roistats_long <- roistats |>
  select(-matches('^\\.')) |> # remove ...1 and ...2 (sub brik weirdness from 3dROIStats)
  filter(!grepl('inv.bak|^name$',name)) |> # remove accidental nested back dir, remove redundant header
                                           # (too many files, multile ROIStats via xargs)
  pivot_longer(cols=matches('_\\d+$'), names_to="measure") |>
  mutate(name=gsub('../output/|.nii.gz_0\\[.*\\]$','',name)) |>
  separate(name,c("id","run","fname"),sep="/") |>
  separate(measure,c("measure","roinum"))

### roinum to label lookup
# 1 and 2 set by 3dcalc in ../atlases/Makefile '1*v*step(v-c) + 2*c + h'
labs <- read.table('../../atlases/HarOx-thr50-CaudPutPalAcc_labels.tsv',sep="\t",col.names=c("roinum","label")) |>
        rbind(c(1,"ventricles"),
              c(2,"CC"))
roistats_long_lab <- roistats_long |> merge(labs, by="roinum") 

## resampe to semi wide -- one row per roi+run pair (NZMean,NZsigma, and NZ voxel count)
roistats_per_roi <- roistats_long_lab |> pivot_wider(names_from=measure,values_from=value)

write.csv(roistats_per_roi, file='task-CaudPutPalAccVentCC.csv', row.names=F, quote=F)

