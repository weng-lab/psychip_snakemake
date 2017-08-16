shell.prefix("set -eo pipefail; ")

configfile: "config.yaml"
localrules: all

ALL_SAMPLES = config["ips"] + config["controls"]
ALL_BED = expand("bed_files/{sample}.bed.gz", sample = ALL_SAMPLES)
PSEUDO = expand("bed_files/psr_{sample}.01.bed.gz bed_files/psr_{sample}.00.bed.gz".split(), sample = config["ips"])
POOLED = ["peaks/pooled_peaks.narrowPeak"]
POOL = ["bed_files/pooled_controls.bed.gz", "bed_files/pooled_inputs.bed.gz"]

#ALL_SAM = expand("mapped_reads/{sample}.raw.sam.gz", sample = ALL_SAMPLES)
#ALL_MAP_RAW = expand("qc/{sample}.raw.flagstat.QC.txt", sample = ALL_SAMPLES)
#ALL_MAP_FINAL = expand("qc/{sample}.final.flagstat.QC.txt", sample = ALL_SAMPLES)

#QC
FLAG_F = expand("qc/{sample}.final.flagstat.QC.txt", sample = ALL_SAMPLES)
FLAG_R = expand("qc/{sample}.raw.flagstat.QC.txt", sample = ALL_SAMPLES)
ALL_QC = expand("qc/{sample}.libComplexity.QC.txt", sample = ALL_SAMPLES)
XCOR = expand("xcor/{sample}.filt.nodup.sample.SE.tagAlign.cc.qc", sample = ALL_SAMPLES)


#rule all:
#	input: PEAKS + POOLED

#rule all:
#	input: ALL_QC + FLAG_F + FLAG_R + XCOR

if not config["tf"]:
	if config["matching"]:
		PEAKS = expand("logs/{sample}_vs_{control}.done", zip, sample=config["ips"], control=config["controls"])	
		FINAL = expand("finalPeaks/{sample}_vs_{control}_final.narrowPeak",zip, sample = config["ips"], control=config["controls"])
	else:
		PEAKS = expand("peaks/{sample}_peaks.narrowPeak", sample = config["ips"])
		FINAL = expand("finalPeaks/{sample}_final.narrowPeak", sample = config["ips"])
		P_FINAL = ["peaks/pooled_final.narrowPeak"]
	
	rule all:
		input: ALL_QC + FLAG_F + FLAG_R + PSEUDO + PEAKS + XCOR + POOLED + FINAL + P_FINAL
		#input: FINAL + P_FINAL

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
else:
	POOLED_SIGNAL = expand("peaks/signals/pooled.fc_signal.bw", sample = config["ips"])
	POOLED_BROAD  = expand("peaks/pooled_peaks.broadPeak.gz", sample = config["ips"])
	NARROW_BROAD  = expand("peaks/{sample}_peaks.broadPeak.gz", sample = config["ips"])
	NARROW_SIGNAL = expand("peaks/signals/{sample}.fc_signal.bw", sample = config["ips"])
	IDR_FINAL = expand("idr/{sample}.IDR0.05.final.narrowPeak.gz", sample = config["ips"])
	FINAL = expand("finalPeaks/{sample}_final.narrowPeak", sample = config["ips"])

#	+ IDR_FINAL

	rule all:
		input: ALL_QC + FLAG_F + FLAG_R + NARROW_SIGNAL + NARROW_BROAD + POOLED_SIGNAL + POOLED_BROAD + XCOR + FINAL

	include: "./modules/TF/0_map_bwa_single"
	include: "./modules/TF/1_filter_single"
	include: "./modules/TF/2_qc_single"
	include: "./modules/TF/3_xcor_single"
	include: "./modules/TF/4_pseudoreps"
	include: "./modules/TF/5_peak_calling_macs_tf_single"
	include: "./modules/TF/5_peak_calling_spp_single"
	include: "./modules/TF/6_idr"
	include: "./modules/TF/6_overlap"



