.SUFFIXES:
.SECONDARY:

example_nii := ../example/10195_20160317_pet1_ref-wholebrain_time-median_vol-median_censor-fd0.3_calc-default_scale-none_tat2.nii.gz

all: ref/JHU-ICBM-CCbody_res-func.nii.gz HarOx-thr50-CaudPutPalAcc_res-func.nii.gz HarOx-thr50-CaudPutPalAcc_labels.tsv atlas-VentCCCaudPutPalAcc_res-func.nii.gz

ref/JHU-ICBM-labels-1mm.nii.gz: | ref/
	cd ref && wget https://neurovault.org/media/images/264/JHU-ICBM-labels-1mm.nii.gz

# TODO: errode mask?
ref/JHU-ICBM-CCbody_res-func.nii.gz: ref/JHU-ICBM-labels-1mm.nii.gz
	3dresample -master $(example_nii) -rmode NN -prefix $@ -inset '3dcalc( -a $< -expr equals(a,5) )'

HarvardOxford-sub-maxprob-thr50-1mm.nii.gz:
	# /usr/share/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr50-1mm.nii.gz
	wget http://neurovault.org/media/images/262/HarvardOxford-sub-maxprob-thr50-1mm.nii.gz

ref/CerebrA.nii.gz: | ref/
	curl -L https://gin.g-node.org/anamanera/CerebrA/raw/master/CerebrA.nii | tee CerebrA.nii | gzip > $@
	3dNotes -h 'curl https://gin.g-node.org/anamanera/CerebrA/raw/master/CerebrA.nii' $@
	3drefit -space MNI $@

ref/ventricles_res-func.nii.gz: ref/CerebrA.nii.gz
	# 37 = R 3rd vent; 88 =L 3rd vent;  41 = R vent; 92 = L vent;
	3dmask_tool -dilate_input -1 -input '3dcalc( -a $< -expr amongst(a,41,92,88,37) )' -prefix /tmp/ref-ventricle-cerebra.nii.gz
	3dresample -master $(example_nii) -rmode NN -prefix $@ -inset /tmp/ref-ventricle-cerebra.nii.gz

atlas-VentCCCaudPutPalAcc_res-func.nii.gz: ref/ventricles_res-func.nii.gz ref/JHU-ICBM-CCbody_res-func.nii.gz HarOx-thr50-CaudPutPalAcc_res-func.nii.gz
	# c and v overlap in 24mm. assign to c instead of v
	3dcalc -v ref/ventricles_res-func.nii.gz \
	       -c ref/JHU-ICBM-CCbody_res-func.nii.gz \
	       -h  HarOx-thr50-CaudPutPalAcc_res-func.nii.gz \
	       -expr '1*v*step(v-c) + 2*c + h' \
	       -prefix $@

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
