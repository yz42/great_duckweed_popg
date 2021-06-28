#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;


open LIST, "</scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/228all.RG.info.cfg";
while (<LIST>){
	chomp;
	my $line=$_;
	my @a=split/\s+/,$line;
	my$smp=$a[2];
	#`mkdir -p $path/sep_smp/$smp`;
	open CFG, ">$path/sep_smp/$smp.cfg";
	print CFG "$line\n";
	close CFG;

	open OUT, ">$path/sep_smp/pindel.call.$smp.sbatch";

	print OUT "#! /bin/bash
# pindel.call.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=10        # the number of CPU cores per node
#SBATCH --mem=36G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.call.$smp      # the name of your job
#SBATCH -o pindel.call.$smp.out # Standard output
#SBATCH -e pindel.call.$smp.err # Standard error

module load palma/2020b  GCC/10.2.0

/home/y/ywang1/soft/pindel/pindel \\
-i $path/sep_smp/$smp.cfg \\
-f /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-T 8  -N -o pindel.res.$smp
\n";
	close OUT;
}
close LIST