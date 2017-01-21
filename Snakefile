configfile: "config.yaml"
localrules: all


ALL_SAMPLES = config["ips"] + config["controls"]

ALL_SAM = expand("mapped_reads/{sample}.raw.sam.gz", sample = ALL_SAMPLES)
ALL_BED = expand("bed_files/{sample}.bed.gz", sample = ALL_SAMPLES)
ALL_ = expand("bed_files/{sample}.bed.gz", sample = ALL_SAMPLES)

rule all:
	input: ALL_SAM + ALL_BED

include: "modules/map_bwa_paired"
include: "modules/filter_paired"
include: "modules/qc_paired"


