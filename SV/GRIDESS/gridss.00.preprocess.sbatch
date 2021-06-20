#! /bin/bash
# gridss.00.preprocess.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4       # the number of CPU cores per node
#SBATCH --mem=10G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.preprocess       # the name of your job
#SBATCH -o gridss.preprocess_%A_%a.out # Standard output
#SBATCH -e gridss.preprocess_%A_%a.err # Standard error

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11 

FILES=($(cat /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/sort.bam.list))
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
echo "$FILENAME"
echo "$SLURM_ARRAY_TASK_ID"

/home/y/ywang1/soft/gridss/gridss \
-s preprocess \
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \
-t 4 \
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/00.preprocess \
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \
$FILENAME 