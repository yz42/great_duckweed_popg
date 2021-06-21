#! /usr/bin/perl

use strict;
use warnings;

die "file?\n" if (@ARGV==0);

# working dir: /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy

# `mkdir -p subpop`;
`mkdir -p sep_smp`;
`mkdir -p all228`;

open LIST, "</scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/basename.list.added";
open OUT_ALL228, ">/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/all228/lumpy.all228.sbatch";
my @B;
my @S;
my @D;

while (<LIST>){
	chomp;
	my @a=split/\s+/,$_;
	open OUT_SEP_SMP, ">/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/sep_smp/$a[0].lumpy.sep_smp.sbatch";
	print OUT_SEP_SMP "#! /bin/bash
# $a[0].lumpy.sep_smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=lumpy.sep_smp.$a[0]       # the name of your job
#SBATCH -o lumpy.sep_smp.$a[0].out # Standard output
#SBATCH -e lumpy.sep_smp.$a[0].err # Standard error

module load  palma/2020b  GCC/10.2.0  OpenMPI/4.0.5  LUMPY/0.3.1 Python/3.8.6 SAMtools/1.11

lumpyexpress \\
	-K /Applic.HPC/Easybuild/skylake/2020b/software/LUMPY/0.3.1-foss-2020b/bin/lumpyexpress.config \\
    -B $a[1] \\
    -S /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/$a[0].splitters.bam \\
    -D /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/$a[0].discordants.bam \\
    -o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/sep_smp/$a[0].vcf\n";
	close OUT_SEP_SMP;

	push @B, $a[1];
	push @S, "/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/$a[0].splitters.bam";
	push @D, "/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/$a[0].discordants.bam";
}

my $b=join(",",@B);
my $d=join(",",@D);
my $s=join(",",@S);

print OUT_ALL228 "#! /bin/bash
# lumpy.all228.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=10        # the number of CPU cores per node
#SBATCH --mem=64G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=144:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=lumpy.all228      # the name of your job
#SBATCH -o lumpy.all228.out # Standard output
#SBATCH -e lumpy.all228.err # Standard error

module load  palma/2020b  GCC/10.2.0  OpenMPI/4.0.5  LUMPY/0.3.1 Python/3.8.6 SAMtools/1.11

lumpyexpress \\
	-K /Applic.HPC/Easybuild/skylake/2020b/software/LUMPY/0.3.1-foss-2020b/bin/lumpyexpress.config \\
    -B $b \\
    -S $s \\
    -D $d \\
    -o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/all228/lumpy.all228.vcf\n";

close OUT_SEP_SMP;

__END__



lumpyexpress \
    -B sample.bam \
    -S sample.splitters.bam \
    -D sample.discordants.bam \
    -o sample.vcf