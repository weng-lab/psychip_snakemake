configfile: "config.yaml"
localrules: all


ALL_SAMPLES = config["ips"] + config["controls"]

#ALL_SAM = expand("mapped_reads/{sample}.raw.sam.gz", sample = ALL_SAMPLES)
#ALL_BED = expand("bed_files/{sample}.bed.gz", sample = ALL_SAMPLES)
#ALL_MAP_RAW = expand("qc/{sample}.raw.flagstat.QC.txt", sample = ALL_SAMPLES)
#ALL_MAP_FINAL = expand("qc/{sample}.final.flagstat.QC.txt", sample = ALL_SAMPLES)
ALL_QC = expand("qc/{sample}.libComplexity.QC.txt", sample = ALL_SAMPLES)
POOL = ["bed_files/pooled_controls.bed.gz", "bed_files/pooled_inputs.bed.gz"]
PSEUDO = expand("bed_files/psr_{sample}.01.bed.gz bed_files/psr_{sample}.00.bed.gz".split(), sample = config["ips"])
POOLED = ["peaks/pooled_peaks.narrowPeak"]
XCOR = expand("xcor/{sample}.filt.nodup.sample.SE.tagAlign.cc.qc", sample = ALL_SAMPLES)

if config["matching"]:
	PEAKS = expand("logs/{sample}_vs_{control}.done", zip, sample=config["ips"], control=config["controls"])	
	FINAL = expand("finalPeaks/{sample}_vs_{control}.narrowPeak",zip, sample = config["ips"], control=config["controls"])
else:
	PEAKS = expand( "peaks/{sample}_peaks.narrowPeak", sample = config["ips"])
	FINAL = expand("finalPeaks/{sample}.narrowPeak", sample = config["ips"])
#	GAPPED = expand("peaks/{sample}_peaks.broadPeak", sample = config["ips"])
		
rule all:
	input: ALL_QC + PSEUDO + PEAKS + XCOR + POOLED + FINAL


if config["matching"]:
	if config["paired"]:
		
		include: "modules/0_map_bwa_paired"
		include: "modules/1_filter_paired"
		include: "modules/2_qc_paired"
		include: "modules/3_xcor_paired"
		include: "modules/4_pseudoreps"
		include: "modules/5_peak_calling_macs_paired_matching"
		include: "modules/6_overlap_matching"

	else:
		
		include: "modules/0_map_bwa_single"
		include: "modules/1_filter_single"
		include: "modules/2_qc_single"
		include: "modules/3_xcor_single"
		include: "modules/4_pseudoreps"
		include: "modules/5_peak_calling_macs_single_matching"
		include: "modules/6_overlap_matching"
else:
	if config["paired"]:
		
		include: "modules/0_map_bwa_paired"
		include: "modules/1_filter_paired"
		include: "modules/2_qc_paired"
		include: "modules/3_xcor_paired"
		include: "modules/4_pseudoreps"
		include: "modules/5_peak_calling_macs_paired"
		include: "modules/6_overlap"

	else:
		
		include: "modules/0_map_bwa_single"
		include: "modules/1_filter_single"
		include: "modules/2_qc_single"
		include: "modules/3_xcor_single"
		include: "modules/4_pseudoreps"
		include: "modules/5_peak_calling_macs_single"
		include: "modules/6_overlap"
