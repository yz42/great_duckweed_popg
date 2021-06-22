#! /bin/bash
# gridss.02.calling.EUR.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=80G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.call.EUR       # the name of your job
#SBATCH -o gridss.call.EUR.out # Standard output
#SBATCH -e gridss.call.EUR.err # Standard error
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=ywang1@uni-muenster.de # your mail address

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11

/home/y/ywang1/soft/gridss/gridss \
--steps call \
--configuration gridss.properties \
-o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.EUR.joint_calling.res.vcf.gz \
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \
-t 1 \
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \
--jvmheap 72g \
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/working \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly09.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly07.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly08.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp010.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp031.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp054.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP190.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP193.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp020.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp022.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp029.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp037.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp044.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP214.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP217.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP218.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP219.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp026.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp049.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP241.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp062.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp104.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/HerbarG1.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/HerbarG2.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp015.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp018.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp023.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp027.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp034.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp042.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp056.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp065.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp066.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp103.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp131.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp136.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp137.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp005.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp013.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp045.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp055.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp060.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp071.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp077.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp078.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp079.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp093.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp102.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp105.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp106.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp108.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp133.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp134.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP192.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP194.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP215.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP239.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp014.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp021.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp041.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp047.bam 