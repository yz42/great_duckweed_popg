#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


my $smp;
if ($ARGV[0]=~/^(\w+)\.cfg/){
        $smp=$1;
} else {
        die "check pass, usage: perl $0 smp.cfg\n";
}

my $path=`pwd`;
chomp $path;


open LIST, "<chr.list";
open CMD, ">sub.all_chr.sh";
open CMD1, ">pindel2vcf.sub.all_chr.sh";
while (<LIST>){
        chomp;
        my $chr=$_;
        `mkdir -p $path/pindel_$chr`;
        open OUT, ">$path/pindel_$chr/pindel.call.$chr.sbatch";

        print OUT "#! /bin/bash
# pindel.call.$chr.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=8       # the number of CPU cores per node
#SBATCH --mem=48G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=36:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.call.$chr.$smp      # the name of your job
#SBATCH -o pindel.call.$chr.$smp.out # Standard output
#SBATCH -e pindel.call.$chr.$smp.err # Standard error

module load palma/2020b  GCC/10.2.0

/home/y/ywang1/soft/pindel/pindel \\
-i $path/$ARGV[0] \\
-f /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-c $chr  -T 4  -N -o pindel.res.$smp.$chr
\n";
        close OUT;
        print CMD "cd $path/pindel_$chr/; sbatch pindel.call.$chr.sbatch\n";

        open OUT1, ">$path/pindel_$chr/pindel.2vcf.$chr.$smp.sbatch";

        print OUT1 "#! /bin/bash
#pindel.2vcf.$smp.$chr.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=12G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.2vcf.$smp.$chr      # the name of your job
#SBATCH -o pindel.2vcf.$smp.$chr.out # Standard output
#SBATCH -e pindel.2vcf.$smp.$chr.err # Standard error

module load palma/2020b  GCC/10.2.0

/home/y/ywang1/soft/pindel/pindel2vcf \\
-P $path/pindel_$chr/pindel.res.$smp.$chr \\
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \\
-R SP2.0_popg228 -d 20210600 \\
-v $path/pindel_$chr/pindel.res.$smp.$chr.all.vcf

echo \"vcf done.\";
\n";
        close OUT1;
        print CMD1 "cd $path/pindel_$chr/; sbatch pindel.2vcf.$chr.$smp.sbatch\n";
}

close CMD1;
close CMD;
close LIST;