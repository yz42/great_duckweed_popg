#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;

# working dir: /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove
`mkdir -p /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-smoove/`;
`mkdir -p /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-genotyped/`;

open LIST, "<basename.bam.list";

while (<LIST>){
  chomp;
  my @a=split/\s+/,$_;
  my $smp=$a[0];
  my $bam=$a[1];

  open OUT, ">/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-smoove/smoove.00.call.$smp.sbatch";
  print OUT "#! /bin/bash
# smoove.00.call.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=smoove.00.call.$smp       # the name of your job
#SBATCH -o smoove.00.call.$smp.out # Standard output
#SBATCH -e smoove.00.call.$smp.err # Standard error

module load  palma/2020b  GCC/10.2.0 Python/2.7.18  SAMtools/1.11  samblaster/0.1.26 Sambamba/0.8.0 BCFtools/1.11 

/home/y/ywang1/bin/smoove call \\
--outdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-smoove/ \\
--name $smp --fasta /scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta \\
-p 1 --genotype $bam \n";
  close OUT;

  open GENOTYPING, ">/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-genotyped/smoove.02.genotyping.$smp.sbatch";
  print GENOTYPING "#! /bin/bash
# smoove.02.genotyping.$smp.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=smoove.02.genotyping.$smp       # the name of your job
#SBATCH -o smoove.02.genotyping.$smp.out # Standard output
#SBATCH -e smoove.02.genotyping.$smp.err # Standard error

module load  palma/2020b  GCC/10.2.0 Python/2.7.18  SAMtools/1.11  samblaster/0.1.26 Sambamba/0.8.0 BCFtools/1.11 

/home/y/ywang1/bin/smoove genotype -d -x -p 1 \\
--outdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-genotyped/ \\
--name $smp-joint \\
--fasta /scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta \\
--vcf /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/merged.sites.vcf.gz \\
$bam \n";
  close GENOTYPING;
}
close LIST;



open MERGE, ">smoove.01.merge.sbatch";
print MERGE "#! /bin/bash
# smoove.01.merge.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=16G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=smoove.01.merge       # the name of your job
#SBATCH -o smoove.01.merge.out # Standard output
#SBATCH -e smoove.01.merge.err # Standard error

module load  palma/2020b  GCC/10.2.0 Python/2.7.18  SAMtools/1.11  samblaster/0.1.26 Sambamba/0.8.0 BCFtools/1.11 

/home/y/ywang1/bin/smoove merge \\
--outdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/ \\
--name merged --fasta /scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-smoove/*.genotyped.vcf.gz\n";
close MERGE;


open JOINT, ">smoove.03.joint.sbatch";
print JOINT "#! /bin/bash
# smoove.01.merge.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=16G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=smoove.03.joint       # the name of your job
#SBATCH -o smoove.03.joint.out # Standard output
#SBATCH -e smoove.03.joint.err # Standard error

module load  palma/2020b  GCC/10.2.0 Python/2.7.18  SAMtools/1.11  samblaster/0.1.26 Sambamba/0.8.0 BCFtools/1.11 

/home/y/ywang1/bin/smoove paste \\
--name 228.joint \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/results-genotyped/*.vcf.gz\n";
close JOINT;


open ANNO, ">smoove.04.anno.sbatch";
print ANNO "#! /bin/bash
# smoove.04.anno.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=16G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=12:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=smoove.04.anno       # the name of your job
#SBATCH -o smoove.04.anno.out # Standard output
#SBATCH -e smoove.04.anno.err # Standard error

module load  palma/2020b  GCC/10.2.0 Python/2.7.18  SAMtools/1.11  samblaster/0.1.26 Sambamba/0.8.0 BCFtools/1.11 

/home/y/ywang1/bin/smoove annotate \\
--gff /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/all.gff3 \\
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/228.joint.smoove.square.vcf.gz | bgzip -c > /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/smoove/228.joint.smoove.square.anno.vcf.gz\n";
close ANNO;