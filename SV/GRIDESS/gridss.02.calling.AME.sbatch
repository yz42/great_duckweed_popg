#! /bin/bash
# gridss.02.calling.AME.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=80G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.call.AME       # the name of your job
#SBATCH -o gridss.call.AME.out # Standard output
#SBATCH -e gridss.call.AME.err # Standard error
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=ywang1@uni-muenster.de # your mail address

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11

/home/y/ywang1/soft/gridss/gridss \
--steps call \
--configuration gridss.properties \
-o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.AME.joint_calling.res.vcf.gz \
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \
-t 1 \
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \
--jvmheap 72g \
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/working \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly00.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly01.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-CC3_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-CC4_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RC1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RC2_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP2_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP4_2.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP6_5.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP8_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp011.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp089.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP189.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-ML1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-ML3_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-DD7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP14.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-HFA10.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-HFA11.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB2_7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB3_7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp087.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RD24.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RR2_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-195.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RL1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RL2_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-100.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-102.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-186.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-408.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-410.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-103.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-206.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp004.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp007.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp009.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp030.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp085.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp008.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp032.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp070.bam 