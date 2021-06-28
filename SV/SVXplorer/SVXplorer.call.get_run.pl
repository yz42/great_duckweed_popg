#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
#working dir: /home/y/ywang1/scr/01.duckweed/popgenomics/SV/svXplorer

my %hash;
my @order;
open LIST, "<basename.list.added.list";
while (<LIST>){
	chomp;
	my @a=split/\s+/,$_;
	$hash{$a[0]}{'bam'}=$a[1];
	push @order, $a[0];
}
close LIST;

open LIST, "<splitters.bam.list";
while (<LIST>){
	chomp;
	my $line=$_;
	for my $smp (@order){
		if ($line=~/$smp/){
			$hash{$smp}{'split'}=$line;
		}
	}
}
close LIST;

open LIST, "<discordants.bam.list";
while (<LIST>){
	chomp;
	my $line=$_;
	for my $smp (@order){
		if ($line=~/$smp/){
			$hash{$smp}{'disc'}=$line;
		}
	}
}
close LIST;

for my $smp (@order){
	open OUT, ">SVXplorer.calling.$smp.sbatch";
	my $a=basename($hash{$smp}{'disc'});
	my $b=basename($hash{$smp}{'split'});
	my $c=basename($hash{$smp}{'bam'});
	print "checking:\n";
	print "$smp\t$a\t$b\t$c\n";
	print OUT "#! /bin/bash
# SVXplorer.calling.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=48G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=36:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=SVXplorer.calling.$smp      # the name of your job
#SBATCH -o SVXplorer.calling.$smp.out # Standard output
#SBATCH -e SVXplorer.calling.$smp.err # Standard error

module load   palma/2020b  GCC/10.2.0 BCFtools/1.11 SAMtools/1.11 Python/2.7.18

/home/y/ywang1/soft/SVXplorer/bin/SVXplorer \\
-c /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/chr_2b_ignored.list \\
-w /home/y/ywang1/scr/01.duckweed/popgenomics/SV/svXplorer/$smp -f \\
$hash{$smp}{'disc'}  \\
$hash{$smp}{'split'} \\
$hash{$smp}{'bam'} \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta\n";
}


__END__
#! /bin/bash
# SVXplorer.calling.SP185.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=80G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.call.IND       # the name of your job
#SBATCH -o gridss.call.IND.out # Standard output
#SBATCH -e gridss.call.IND.err # Standard error

module load   palma/2020b  GCC/10.2.0 BCFtools/1.11 SAMtools/1.11 Python/2.7.18

/home/y/ywang1/soft/SVXplorer/bin/SVXplorer \
-c /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/svXplorer/chr_2b_ignored.list \
-w /home/y/ywang1/scr/01.duckweed/popgenomics/SV/svXplorer/test \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/SP185.discordants.bam  \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/lumpy/SP185.splitters.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP185.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta