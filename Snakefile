configfile: "config.yaml"
localrules: all


ALL_SAMPLES = config["ips"] + config["controls"]

ALL_SAM = expand("mapped_reads/{sample}.raw.sam.gz", sample = ALL_SAMPLES)
ALL_BED = expand("bed_files/{sample}.bed.gz", sample = ALL_SAMPLES)
ALL_MAP_RAW = expand("qc/{sample}.raw.flagstat.QC.txt", sample = ALL_SAMPLES)
ALL_MAP_FINAL = expand("qc/{sample}.final.flagstat.QC.txt", sample = ALL_SAMPLES)
ALL_QC = expand("qc/{sample}.libComplexity.QC.txt", sample = ALL_SAMPLES)

rule all:
	input: ALL_SAM + ALL_BED + ALL_MAP_RAW + ALL_MAP_FINAL + ALL_QC

include: "modules/0_map_bwa_paired"
include: "modules/1_filter_paired"
include: "modules/2_qc_paired"


