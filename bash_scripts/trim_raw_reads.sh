{
usage="$(basename "$0") [-h] [-l <SRA_list>] [-d <working_directory>]
Script to perform raw read preprocessing using fastp
    -h show this help text
    -l path/file to tab-delimitted sra list
    -d working directory"
options=':h:l:d:'
while getopts $options option; do
    case "$option" in
        h) echo "$usage"; exit;;
	l) l=$OPTARG;;
	d) d=$OPTARG;;
	:) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
       \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
     esac
done

echo $l
echo $d

# mandatory arguments
if [ ! "$l" ] || [ ! "$d"]; then
    echo "arguments -l and -d must be provided"
    echo "$usage" >&2; exit 1
fi

begin=`date +%s`

echo "load required modules"
module load fastqc/0.11.4
module load multiqc/1.12
module load fastp/0.20.1

echo "create file storing environment"
mkdir -p sra_files
mkdir -p raw_reads
mkdir -p cleaned_reads/merged_reads
mkdir -p cleaned_reads/unmerged_reads

echo "Downloading SRA files from the given list of accessions"
module load sra-toolkit/3.0.2
cd sra_files
prefetch --max-size 800G -O ./ --option-file ../${l}
ls | grep SRR > sra_list
cd ..
echo "SRA files were downloaded in current directory"
echo ""

echo "Getting fastq files from SRA files"
cd sra_files
while read i; do 
	cd "$i" 
	fastq-dump --split-files --gzip "$i".sra 
	# the --split-files option is needed for PE data
	mv "$i"*.fastq.gz ../../raw_reads/ 
	cd ..
done<sra_list
cd ..
module unload sra-toolkit/3.0.2
echo "Done"


###################################
# Quality check of raw read files #
###################################

echo "Perform quality check of raw read files"
cd raw_reads
ls
pwd
while read i; do 
  	fastqc "$i"_1.fastq.gz # run fastqc on each read for lane 1
  	fastqc "$i"_2.fastq.gz # run fastqc on each read for lane 2
done<../sra_files/sra_list
multiqc . # run multiqc and produce report
cd ..

####################################################
# Trimming downloaded Illumina datasets with fastp #
####################################################

echo "Trimming downloaded Illumina datasets with fastp."
cd raw_reads
pwd
ls *.fastq.gz | cut -d "." -f "1" | cut -d "_" -f "1" | sort | uniq > fastq_list
while read z ; do 
# Perform trimming
# -----------------------------------------------
# infile(s) --in1 and --in2
# Merge paired end reads that overlap into a single read
# Reads with average quality of "e" are discarded. "q" is the threshold for quaifying a base
# Reads with "u" % bases under q values are discarded and reads with length "l" after filtering are discarded.
# The nucleotide sequence for the adapter used for sequencing --adapter_sequence and The adapter sequence for read 2 in paired end sequencing --adapter_sequence_r2 
# M(The minimum average in a sliding window to not remove bases, W(The number of bases in a qualifying window, 5(Use sliding window to trim leading sequences with averages << M), and 3(Use sliding window to trim tailing sequences with averages<M) 
# c - Overlap analysis to correct bases with low reads. Only for paired end reads
# -----------------------------------------------
fastp -i "$z"_1.fastq.gz -I "$z"_2.fastq.gz \
      -m --merged_out ${d}/cleaned_reads/merged_reads/"$z"_merged.fastq \
      --out1 ${d}/cleaned_reads/unmerged_reads/"$z"_unmerged1.fastq --out2 ${d}/cleaned_reads/unmerged_reads/"$z"_unmerged2.fastq \
      -e 25 -q 15 \
      -u 40 -l 15 \
      --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
      --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
      -M 20 -W 4 -5 -3 \
      -c 
cd ../cleaned_reads/merged_reads
gzip "$z"_merged.fastq
cd ../../raw_reads
done<fastq_list
cd ..
echo ""



#######################################
# Quality check of cleaned read files #
#######################################

echo "Perform check of cleaned read files"
cd ${d}/cleaned_reads/merged_reads
pwd
while read i; do 
	fastqc "$i"_merged.fastq.gz # run fastqc on each read
done<${d}/sra_files/sra_list

 }
