#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;

open LIST, "<$ARGV[0]";
#ChrS01
#ChrS02
open OUT, ">run.all_chr.intansv_merge.sh";

while (<LIST>){
    chomp;
    my $line=$_;

    open CMD, ">$path/$line/$line.intansv_merge.sbatch";
    print OUT "cd $path/$line/; sbatch $line.intansv_merge.sbatch\n";

    print CMD "#! /bin/bash
# $line.intansv_merge.sbatch

#SBATCH --export=ALL              # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=16G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=intansv_merge.$line       # the name of your job
#SBATCH -o intansv_merge.$line.out # Standard output
#SBATCH -e intansv_merge.$line.err # Standard error

module load palma/2020b  GCC/10.2.0  OpenMPI/4.0.5  R/4.0.3

Rscript /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/intansv/per_chr/intansv.merge.R $line\n";
    close CMD;

}
close LIST;
close OUT;



__END__
#/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/intansv/per_chr/intansv.merge.R
#module load palma/2020b  GCC/10.2.0  OpenMPI/4.0.5  R/4.0.3

.libPaths('~/R/library/')
library("intansv")

#setwd("/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/intansv")
source("/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/intansv/extra.func.R")

args<-commandArgs(T)

if (!grep("ChrS\\d+",args[1])){
	stop("par not match!\n")
} else {
	warning<- paste0("Working with ",args[1],"!")
	print(warning)
}


jasmine <- readJasmine(paste0("./jasmine.",args[1],".res"))
breakdancer <- readBreakDancer_fix(paste0("./breakdancer.",args[1],".res"))
delly <-readDelly_fix(paste0("./delly.",args[1],".res"))
lumpy <- readLumpy_fix(paste0("./lumpy.",args[1],".res"))
cnvcaller <- readCNVcaller(paste0("./CNVcaller.",args[1],".res"))

sv_all_methods <- methodsMerge_fix(breakdancer,delly,lumpy,jasmine,cnvcaller)

for (sv_type in c("ins","inv","dup","del")){	
  out_name=paste0("./",sv_type,".merged.csv")
  write.csv(sv_all_methods[[sv_type]],out_name, row.names = FALSE, quote = FALSE)
}

save.image("./intansv.merge.per_chr.RData")