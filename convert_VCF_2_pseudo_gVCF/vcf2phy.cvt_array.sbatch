#! /bin/bash
# cvt_array.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=4G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=cvtgVCF2fasta       # the name of your job
#SBATCH --output=cvtgVCF2fasta._%A_%a.out        # the file where output is written to (stdout & stderr)
#SBATCH -e cvtgVCF2fasta._%A_%a.err # Standard error

module load  palma/2020b  GCCcore/10.2.0 Python/2.7.18
FILES=($(ls -1 `pwd`/*.pseudo_gvcf))
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
echo "$FILENAME"
echo "$SLURM_ARRAY_TASK_ID"
/home/y/ywang1/bin/vcf2phylip.py -i $FILENAME -f 





export FILES=($(ls -1 `pwd`/*.pseudo_gvcf))
# get size of array
NUMFASTQ=${#FILES[@]}
# now subtract 1 as we have to use zero-based indexing (first cell is 0)
ZBNUMFASTQ=$(($NUMFASTQ - 1))
# now submit to SLURM
if [ $ZBNUMFASTQ -ge 0 ]; then
	echo "start with $ZBNUMFASTQ"
	sbatch --array=0-$ZBNUMFASTQ cvt_array.sbatch
fi