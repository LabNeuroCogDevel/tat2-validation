.SUFFIXES:
.SECONDARY:

example_nii := ../example/10195_20160317_pet1_ref-wholebrain_time-median_vol-median_censor-fd0.3_calc-default_scale-none_tat2.nii.gz

all: ref/JHU-ICBM-CCbody_res-func.nii.gz

ref/JHU-ICBM-labels-1mm.nii.gz: | ref/
	cd ref && wget https://neurovault.org/media/images/264/JHU-ICBM-labels-1mm.nii.gz

# TODO: errode mask?
ref/JHU-ICBM-CCbody_res-func.nii.gz: ref/JHU-ICBM-labels-1mm.nii.gz
	3dresample -master $(example_nii) -rmode NN -prefix $@ -inset '3dcalc( -a $< -expr equals(a,5) )'

%/:
	mkdir -p $@
