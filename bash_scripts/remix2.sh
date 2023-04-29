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
mkdir -p cleaned_reads/merged_2_reads
mkdir -p cleaned_reads/unmerged_2_reads

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
# Insert description of -i and -I parameters here
# Insert description of -m, --merged_2_out, --out1, and --out2 parameters here
# Insert description of -e and -q here
# Insert description of -u and -l here
# Insert description of --adapter_sequence and --adapter_sequence_r2 here
# Insert description of -M, -W, -5, and -3 here
# Insert description of -c here
# -----------------------------------------------
fastp -i "$z"_1.fastq.gz -I "$z"_2.fastq.gz \
      -m --merged_out ${d}/cleaned_reads/merged_2_reads/"$z"_merged_2.fastq \
      --out1 ${d}/cleaned_reads/unmerged_2_reads/"$z"_unmerged_21.fastq --out2 ${d}/cleaned_reads/unmerged_2_reads/"$z"_unmerged_22.fastq \
      -e 20 -q 15 \
      -u 30 -l 15 \
      --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
      --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
      -M 20 -W 4 -5 -3 \
      -c 
cd ../cleaned_reads/merged_2_reads
gzip "$z"_merged_2.fastq
cd ../../raw_reads
done<fastq_list
cd ..
echo ""



#######################################
# Quality check of cleaned read files #
#######################################

echo "Perform check of cleaned read files"
cd ${d}/cleaned_reads/merged_2_reads
pwd
while read i; do 
	fastqc "$i"_merged_2.fastq.gz # insert description here
done<${d}/sra_files/sra_list

 }
