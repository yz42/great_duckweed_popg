#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;


open LIST, "<chr.list";
while (<LIST>){
	chomp;
	my $chr=$_;
	`mkdir -p $path/pindel_$chr`;
	open OUT, ">$path/pindel_$chr/pindel.call.$chr.sbatch";

	print OUT "#! /bin/bash
# pindel.call.$chr.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=10        # the number of CPU cores per node
#SBATCH --mem=32G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=36:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.call.$chr      # the name of your job
#SBATCH -o pindel.call.$chr.out # Standard output
#SBATCH -e pindel.call.$chr.err # Standard error

module load palma/2020b  GCC/10.2.0

/home/y/ywang1/soft/pindel/pindel \\
-i /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/228all.RG.info.cfg \\
-f /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-c $chr  -T 8  -N -o pindel.res.$chr
\n";
	close OUT;
}
close LIST;