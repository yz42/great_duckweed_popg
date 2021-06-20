#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n perl $0 batch.list\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;
# `mkdir -p $path`;
# my $batch_num=$ARGV[1];
# chmod $batch_num;

# die "err: batch_num is not int or is empty\n" if (not /^-?\d+$/);

# my @bam;
my $num=0;
open BATCH_LIST, "<$ARGV[0]";
while (<BATCH_LIST>){
	chomp;
	my $x=$_;
	my $n=sprintf("%02d",$num);
	open LIST, "<./prepare4assemble/$x";
	open OUT, ">gridss.01.assemble$n.$x.sbatch";

	print OUT "#! /bin/bash
# gridss.xx.assemble$n.$x.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=10        # the number of CPU cores per node
#SBATCH --mem=64G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.assemble$n       # the name of your job
#SBATCH -o gridss.assemble$n.out # Standard output
#SBATCH -e gridss.assemble$n.err # Standard error
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=ywang1\@uni-muenster.de # your mail address

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11 

/home/y/ywang1/soft/gridss/gridss \\
--steps assemble \\
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly$n.bam \\
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-t 8 \\
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \\
--jvmheap 32g \\
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/working ";

	while (<LIST>){
		chomp;
		my @a=split/\s+/,$_;
		print OUT "\\\n$a[-1] ";
	}
	close LIST;
	close OUT;

	$num++;
}
close BATCH_LIST;

