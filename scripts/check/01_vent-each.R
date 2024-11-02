#!/usr/bin/env Rscript

# look at each ventricle ROI separately   
# similar to 01_ventsummary.R but with many more smaller ROIs
# used to see if we expect any difference with different definitions of ROIs
# 20241102WF - init
library(dplyr)
library(tidyr)
library(ggplot2)
# input like
# GroupBy(name)	mean(NZMean_41)	...	max(Max_37)
rois <- list(v1a2_L=92,v1a2_R=41,
             v3rd_L=80,v3rd_R=29,
             v4th_L=88,v4th_R=37)
rois <- data.frame(label=names(rois), roi=unname(unlist(rois)))

d <- read.table('eachvent_summary.tsv',
                #text=system(intern=T,'head -n 99 eachvent_summary.tsv'),
                sep="\t",header=T) %>%
   rename_with(\(x) gsub('GroupBy.|_0.$|\\.$','',x)) %>%
   mutate(name=gsub('.*(rac\\d).*(\\d{5}_\\d{8}).*','\\2_\\1',name))

long <- d |>
   gather('measures','value',-name) |>
   separate(measures, c('smry','metric','roi')) |>
   merge(rois, by='roi')

mean_mean <- long |>
   filter(smry=='mean',
          metric%in% c('NZMean'),
          value > 300,
          value < 2000)
wide <- mean_mean %>% select(-roi,-smry,-metric) %>% spread(label,value)
#               name   v1a2_L   v1a2_R   v3rd_L   v3rd_R   v4th_L   v4th_R
#10195_20160317_rac1 773.5750 765.7954 842.3859 815.1363 770.8713 793.7136
#10195_20160317_rac2 753.4942 738.6630 845.6076 788.6099 819.3661 739.4795

vox_pairs <- t(combn(names(wide)[-1],2))
tstats <- apply(vox_pairs,1, \(pair){
                   x <- wide[[ pair[1] ]]; y <- wide[[ pair[2] ]]
                   #m <- mean(c(x,y),na.rm=T)
                   center <- (x-y)/741*100
                   t.test(center)}) 

tstats_long <- data.frame(vox_pairs,meanpdiff=sapply(tstats,\(x) x$estimate),tstat=sapply(tstats,\(x) x$statistic))
ggplot(tstats_long) +
   aes(x=X1,y=X2, label=round(meanpdiff,2)) +
   geom_point(aes(color=meanpdiff, size=abs(tstat))) +
   geom_label(alpha=.3,vjust=1) +
   scale_color_gradient2(low='blue',high='red',mid='gray') +
   see::theme_modern() +
   labs(title="ttest: % roi-roi mean diff from overall mean (741)")

ggplot(mean_mean ) +
   aes(x=label, y=value, color=label) +
   geom_violin()+
   #geom_jitter(alpha=.3,height=0) +
   geom_line(alpha=.3,aes(group=name)) +
   facet_wrap(~metric) +
   see::theme_modern() +
   labs(color='ROI', title='acquisition mean of ventricle ROIs')


long |>
   filter(smry=='mean', metric%in% c('NZcount'))|>
   group_by(label) |> mutate(prct=(1-(max(value,na.rm=T)-value)/max(value,na.rm=T))*100) |>
   ggplot() +
   aes(x=label, y=prct, color=label) +
   geom_violin()+
   #geom_jitter(alpha=.3,height=0) +
   geom_line(alpha=.3,aes(group=name)) +
   facet_wrap(~metric) +
   see::theme_modern() +
   labs(color='ROI', title="acquisition's ventricle coverage", y="Percent ROI coverage")
