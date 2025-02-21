library(dplyr)
library(tidyr)
d <- read.table('../../stats/r2-x3_atlas-VentCCCaudPutPalAcc_roistats.tsv',header=T,sep="\t")
long <- d |>
   mutate(name=gsub('.*/(\\d{5}_\\d{8})/.*(r2Map|r2prime|r2s).*','\\1/\\2', name),
          proc=grepl('proc',name)) |>
   separate(name,c('ld8','map'),sep='/') |>
   gather('measure','value',-ld8,-map,-proc) |> filter(!is.na(value)) |>
   separate(measure, c("measure","roinum"))

roi <- read.table('../../atlases/HarOx-thr50-CaudPutPalAcc_labels.tsv',
                  col.names=c("roinum","roilab"),sep="\t") |>
       rbind(c(1,'Vent'),
             c(2, 'CC'))
long.roilab <- long |> merge(roi, on="roinum")

long.roilab.norep <- long.roilab |>
   group_by(ld8,map,measure,roilab) |> mutate(n=n()) |>
   filter(n<2 | proc) |> ungroup() |> select(-n,-proc)

semiwide <- long.roilab.norep |> select(-roinum) |>
   #pivot_wider(names_from=c("map","measure"), id_cols=c("ld8","roilab"), values_from="value")
   pivot_wider(names_from=c("measure"), id_cols=c("ld8","map","roilab"), values_from="value")

write.csv(semiwide, '../../stats/r2-x3_atlas-VentCCCaudPutPalAcc_roistats-semiwide.tsv', row.names=F, quote=F)
