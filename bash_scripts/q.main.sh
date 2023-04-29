#!/bin/sh
#SBATCH --account=utu-biol4310
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -o slurm-%j.out-%N
#SBATCH -e slurm-%j.err-%N

wd=~/BIOL_4310/exercises/exercise_4/trimming_raw_reads
cd $wd
bash bash_scripts/remix2.sh -l raw_reads_SRA_list.txt -d $wd
