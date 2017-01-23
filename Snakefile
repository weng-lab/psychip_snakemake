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
PEAKS = expand( "peaks/{sample}_peaks.narrowPeak", sample = config["ips"])
GAPPED = expand("peaks/{sample}_peaks.broadPeak", sample = config["ips"])
POOLED = ["peaks/pooled_peaks.narrowPeak"]
FINAL = expand("finalPeaks/{sample}.narrowPeak", sample = config["ips"])

#rule all:
#	input: ALL_SAM + ALL_BED + ALL_MAP_RAW + ALL_MAP_FINAL + ALL_QC 

rule all:
	input: ALL_QC + PSEUDO + PEAKS + GAPPED + POOLED + FINAL

include: "modules/0_map_bwa_paired"
include: "modules/1_filter_paired"
include: "modules/2_qc_paired"
include: "modules/3_xcor"
include: "modules/4_pseudoreps"
include: "modules/5_peak_calling_macs_paired"
include: "modules/6_overlap"


