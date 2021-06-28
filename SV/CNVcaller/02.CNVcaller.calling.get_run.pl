#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;


open LIST, "</scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/228all.RG.info.cfg";
open CMD, ">02.CNVcaller.calling.run_all.sh";
while (<LIST>){
	chomp;
	my $line=$_;
	my @a=split/\s+/,$line;
	my $bam=$a[0];
	my $smp=$a[2];
	#`mkdir -p $path/sep_smp/$smp`;
	# open CFG, ">$path/sep_smp/$smp.cfg";
	# print CFG "$line\n";
	# close CFG;

	#open OUT, ">$path/sep_smp/$smp/CNVcaller.call.$smp.sbatch";
	open OUT, ">./CNVcaller.call.$smp.sbatch";

	print OUT "#! /bin/bash
# CNVcaller.call.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=4G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=1:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=CNVcaller.call.$smp      # the name of your job
#SBATCH -o CNVcaller.call.$smp.out # Standard output
#SBATCH -e CNVcaller.call.$smp.err # Standard error

module load  palma/2020b  GCCcore/10.2.0 GCC/10.2.0  SAMtools/1.11 Perl/5.32.0 Python/3.8.6 

bash /home/y/ywang1/soft/CNVcaller/Individual.Process.sh -b $bam -h $smp -d /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/window.link -s none \n";
	close OUT;
	#print CMD "cd $path/sep_smp/$smp/; sbatch CNVcaller.call.$smp.sbatch\n";
	print CMD "sbatch CNVcaller.call.$smp.sbatch\n";
}
close LIST;
close CMD;