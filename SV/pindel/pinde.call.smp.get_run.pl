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

	open OUT1, ">$path/merge_sample/pindel.2vcf.$smp.sbatch";
	print OUT1 "#! /bin/bash
# pindel.2vcf.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=12G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.2vcf.$smp      # the name of your job
#SBATCH -o pindel.2vcf.$smp.out # Standard output
#SBATCH -e pindel.2vcf.$smp.err # Standard error

module load palma/2020b  GCC/10.2.0

/home/y/ywang1/soft/pindel/pindel2vcf \\
-P $path/sep_smp/pindel.res.$smp \\
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-R SP2.0_popg228 -d 20210600 \\
-v $path/merge_sample/pindel.res.$smp.all.vcf

grep -v \"JN160603.2\" $path/merge_sample/pindel.res.$smp.all.vcf | grep -v \"JQ804980.1\" | grep -v \"pseudo0\" > $path/merge_sample/pindel.res.$smp.all.nuc_nopseudo.vcf
echo \"vcf done.\"
\n";
	close OUT1;
}
close LIST;

__END__
/home/y/ywang1/soft/pindel/pindel2vcf -p /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/sep_smp/pindel.res.Sp118 -r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta -R 1000GenomesPilot-NCBI36 -d 20101123 -v sample3chr20_D.vcf