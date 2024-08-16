.SUFFIXES:
.SECONDARY:

example_nii := ../example/10195_20160317_pet1_ref-wholebrain_time-median_vol-median_censor-fd0.3_calc-default_scale-none_tat2.nii.gz

all: ref/JHU-ICBM-CCbody_res-func.nii.gz HarOx-thr50-CaudPutPalAcc_res-func.nii.gz HarOx-thr50-CaudPutPalAcc_labels.tsv

ref/JHU-ICBM-labels-1mm.nii.gz: | ref/
	cd ref && wget https://neurovault.org/media/images/264/JHU-ICBM-labels-1mm.nii.gz

# TODO: errode mask?
ref/JHU-ICBM-CCbody_res-func.nii.gz: ref/JHU-ICBM-labels-1mm.nii.gz
	3dresample -master $(example_nii) -rmode NN -prefix $@ -inset '3dcalc( -a $< -expr equals(a,5) )'

HarvardOxford-sub-maxprob-thr50-1mm.nii.gz:
	# /usr/share/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr50-1mm.nii.gz
	wget http://neurovault.org/media/images/262/HarvardOxford-sub-maxprob-thr50-1mm.nii.gz

HarOx-thr50-CaudPutPalAcc_res-func.nii.gz: HarvardOxford-sub-maxprob-thr50-1mm.nii.gz
	3dresample -master $(example_nii) -rmode NN -prefix $@ \
		-inset '3dcalc( -a $< -expr amongst(a,5,16,6,17,11,21,7,18)*a )'
HarOx-thr50-CaudPutPalAcc_labels.tsv: 
	# xml from neurodebian fsl atlas data package
	perl -lne 'print($$1+1, "\t$$2") if m/index="(\d+)".*>([^<]*)</' \
		/usr/share/fsl/data/atlases/HarvardOxford-Subcortical.xml |\
		grep -P '^(5|16|6|17|11|21|7|18)\t' > $@

	
%/:
	mkdir -p $@
