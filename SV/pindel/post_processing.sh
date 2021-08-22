#####post processing of SVs

###merge samples into population-level (SVXplorer, Pindel, and CNVcaller)
module load palma/2020b GCC/10.2.0
/home/y/ywang1/soft/SURVIVOR/Debug/SURVIVOR merge /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/merge_smp/vcf.list 0.2 1 1 0 0 50 /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/merge_smp/svxplorer.merged.vcf

module load palma/2020b GCC/10.2.0
/home/y/ywang1/soft/SURVIVOR/Debug/SURVIVOR merge /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/merge_sample/vcf.list 0.2 1 1 0 0 50 /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/merge_sample/pindel.merged.vcf

#try Jasmine: Population-scale structural variant comparison and analysis
#! /bin/bash
# pindel.jas.merge.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=24        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.jas.merge    # the name of your job
#SBATCH -o pindel.jas.merge.out # Standard output
#SBATCH -e pindel.jas.merge.err # Standard error

module load palma/2020b Miniconda3/4.9.2
source activate jas_env

/home/y/ywang1/.conda/envs/jas_env/bin/jasmine \
--ignore_strand threads=20 max_dist=500 k_jaccard=8 min_seq_id=0.25 \
file_list=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/merge_sample/vcf.list \
out_file=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/merge_sample/Pindel.jas.merged.vcf

###for SVXplorer
#! /bin/bash
# svXplorer.jas.merge.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=24        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=svXplorer.jas.merge    # the name of your job
#SBATCH -o svXplorer.jas.merge.out # Standard output
#SBATCH -e svXplorer.jas.merge.err # Standard error

module load palma/2020b Miniconda3/4.9.2
#/Applic.HPC/Easybuild/skylake/2020b/software/Miniconda3/4.9.2/bin/conda activate jas_env
source activate jas_env
/home/y/ywang1/.conda/envs/jas_env/bin/jasmine \
--ignore_strand threads=10 max_dist=500 k_jaccard=8 min_seq_id=0.25 \
file_list=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/merge_smp/vcf.list \
out_file=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/merge_smp/svXplorer.jas.merged.vcf



###identify gaps from genome
perl -ne 'chomp;if( />(.*)/){$head = $1; $i=0; next};@a=split("",$_); foreach(@a){$i++; if($_ eq "N" && $s ==0 ){$z=$i-1; print "$head\t$z"; $s =1}elsif($s==1 && $_ ne "N"){$j=$i-1;print "\t$j\n";$s=0}}' /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta > /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/SP_combined.N.bed
bedtools getfasta -fi /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta -bed /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/SP_combined.N.bed > SP_combined.N.bed.fa


######filtering
#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;


open LIST, "<$ARGV[0]";
open OUT, ">SURVIVOR.filter.run_all.sh";
#SVXplorer	/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/merge_smp/svxplorer.merged.vcf
while (<LIST>){
	chomp;
	my @a=split/\s+/,$_;
	print OUT "/home/y/ywang1/soft/SURVIVOR/Debug/SURVIVOR filter \\
$a[1] \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/SP_combined.N.least_20nt.bed \\
50 11466534 0.02 5 \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/intansv/$a[0].filter.PASS.vcf";
}

close LIST;
close OUT;


