#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;

open LIST, "<$ARGV[0]";
# readgroup:SP143 platform:ILLUMINA       map:/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP143.sort.bam      readlen:142.29  lib:SP143       num:10001       lower:38.30     upper:520.84    mean:253.29      std:60.17       SWnormality:-31.85      exe:samtools view
# readgroup:SP145 platform:ILLUMINA       map:/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP145.sort.bam      readlen:141.32  lib:SP145       num:10001       lower:37.33     upper:515.29    mean:247.55      std:59.60       SWnormality:-34.25      exe:samtools view
# readgroup:SP148 platform:ILLUMINA       map:/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP148.sort.bam      readlen:143.58  lib:SP148       num:10001       lower:43.69     upper:503.93    mean:251.52      std:57.45       SWnormality:-30.61      exe:samtools view

while (<LIST>){
    chomp;
    my $line=$_;
    my @a=split/\s+/,$line;
    my @b=split/\:/,$a[0];
    my $smp=$b[1];
    open CFG, ">$smp.brkdc.cfg";
    open CMD, ">$smp.brkdc.sbatch";
    print CFG "$line\n";
    close CFG;

    print CMD "#! /bin/bash
# $smp.brkdc.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=breakdancer.$smp       # the name of your job
#SBATCH -o breakdancer.$smp.out # Standard output
#SBATCH -e breakdancer.$smp.err # Standard error

module load  palma/2020b  GCC/10.2.0 

/home/y/ywang1/bin/breakdancer-max /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Breakdancer/separate_smp/$smp.brkdc.cfg\n";
    close CMD;

}
close LIST;




 __END__

#! /bin/bash
# breakdancer.228all.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=10        # the number of CPU cores per node
#SBATCH --mem=20G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=144:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=breakdancer.228all       # the name of your job
#SBATCH -o breakdancer.228all.out # Standard output
#SBATCH -e breakdancer.228all.err # Standard error


module load  palma/2020b  GCC/10.2.0 SAMtools/1.11

/home/y/ywang1/bin/breakdancer-max /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Breakdancer/228all/sort.bam.list.config