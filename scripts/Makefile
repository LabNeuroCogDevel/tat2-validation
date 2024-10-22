check/vent_summary.tsv:
	./check/00_ventrefstats.bash

check/vent-outliers.txt: check/vent_summary_zscored.tsv
check/vent_summary_zscored.tsv: check/vent_summary.tsv
	./check/99_ventrefstast.R

check/bad_alignments.csv:
	./check/00_align-status_tmean-hallquist.bash

