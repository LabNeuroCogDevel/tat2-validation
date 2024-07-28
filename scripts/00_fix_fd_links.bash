#!/usr/bin/env bash
#
# need to catch up some fd.txt file links
# fd.txt from original pipeline MHRest_FM_ica 
#    motion correcion early so pipe diffs dont matter here;
#    base of original used for brnsuwdktm_rest
#
## NB. this fd.txt is output of fsl_motion_outliers (reruns own motion correction)
#      and IS DIFFERENT FROM fd_calc on slicemotion4d motion.par output
#
# 20240727WF - init
#
for d in /Volumes/Hera/preproc/petrest_rac*/brnsuwdktm_rest/1*_2*[0-9]/; do
   test -r "$d/motion_info/fd.txt" && continue
   dryrun ln -s "${d/brnsuwdktm_rest/MHRest_FM_ica}/motion_info/fd.txt" "$d/motion_info/"
   echo "linked fd into $_"
done

# log when fd link was created (and where it points)
# can double check we didn't introduce issues
mkdir -p check
stat -c "%y %N" /Volumes/Hera/preproc/petrest_rac*/brnsuwdktm_rest/1*_2*[0-9]/motion_info/fd.txt > check/fd_link.txt

cut -c1-10 check/fd_link.txt|sort|uniq -c
#  24 2018-04-19
# 181 2018-04-23
# 174 2018-05-22
# 252 2024-07-27

