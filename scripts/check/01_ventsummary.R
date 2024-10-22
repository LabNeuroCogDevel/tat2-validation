#!/usr/bin/env Rscript
# find outliers in sessions with outlier ventrical refernce voxel summary values
# see 00_ventrefstats.bash, makes ../check/vent_summary.tsv

# 20240926WF - init
# 20241022WF - move into own folder. expects to be run from ../
#              badfiles.txt now check/vent-outliers.txt
library(dplyr)
library(tidyr)
library(ggplot2)

d <-
   read.table('check/vent_summary.tsv',header=T) %>%
   rename_with(\(x) gsub('GroupBy.|_0.$|\\.$','',x)) %>%
   mutate(name=gsub('.*(rac\\d).*(\\d{5}_\\d{8}).*','\\2_\\1',name))

d.long <- d %>%
   pivot_longer(-name,names_to="measure") %>%
   group_by(measure) %>%
   mutate(zscore=scale(value))

write.csv(d.long, "check/vent_summary_zscored.csv",row.names=F)

bad <- d.long %>% filter(abs(zscore)>3, !grepl('count', measure)) %>%
   group_by(name) %>%
   summarise(n=n(), mz=max(abs(zscore))) %>% arrange(-mz)

sink('check/vent-outliers.txt')
paste0(collapse=" ", sep=" ",
       'check/all_nii/meants/', bad$name, '.nii.gz') %>% cat
sink()

ggplot(d.long) +
   aes(x=measure,y=value, color=abs(zscore)) +
   geom_jitter() +
   #ggbeeswarm::geom_beeswarm() +
   #aes(x=value) +
   #geom_histogram() +
   #facet_wrap(~measure,scales='free_x') +
   see::theme_modern() +
   scale_color_continuous(limits=c(0,5)) +
   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
