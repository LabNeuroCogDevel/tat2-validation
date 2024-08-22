cd "$(dirname "$0")"
source ../../setup_path.sh # add lncdtool 'fd_calc' to PATH

#../pet_preproc/petrest_rac1/brnsuwdktm_rest/10195_20160317/
for pdir in ../pet_preproc/petrest_rac*/brnsuwdktm_rest/1*_2*/; do
  censor=$pdir/motion_info/censor_fd-0.3.1D
  test -r "$censor" && echo "# have $censor" && continue
  mot=$pdir/motion.par
  ! test -r "$mot" && echo "ERROR: no motion file $mot. canot make $censor" && continue
  dryrun fd_calc 1:3 4:6 deg .3 < $mot | drytee $censor
  break
done

