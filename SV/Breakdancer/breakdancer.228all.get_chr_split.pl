#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;



open LIST, "<chr.list";

while (<LIST>){
  chomp;
  my $chr=$_;

  open OUT, ">breakdancer.228all.$chr.sbatch";
  print OUT"#! /bin/bash
# breakdancer.228all.$chr.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=8        # the number of CPU cores per node
#SBATCH --mem=20G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=breakdancer.228all.$chr       # the name of your job
#SBATCH -o breakdancer.228all.$chr.out # Standard output
#SBATCH -e breakdancer.228all.$chr.err # Standard error


module load  palma/2020b  GCC/10.2.0 SAMtools/1.11

/home/y/ywang1/bin/breakdancer-max -a -o $chr /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Breakdancer/228all/sort.bam.list.config\n";
  close OUT;
}

close LIST;
