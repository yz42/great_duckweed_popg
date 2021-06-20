#! /bin/bash
# SVseq2_array.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=4G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=cvtgVCF2fasta       # the name of your job
#SBATCH --output=cvtgVCF2fasta._%A_%a.out        # the file where output is written to (stdout & stderr)
#SBATCH -e cvtgVCF2fasta._%A_%a.err # Standard error
#SBATCH --chdir=

module load  palma/2020b  GCCcore/10.2.0 Python/2.7.18
FILES=`cat chr.list`
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
echo "$FILENAME"
echo "$SLURM_ARRAY_TASK_ID"

/home/y/ywang1/soft/SVseq2/SVseq2_2 -r /scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta -b /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/228.bam.list -c $FILENAME --o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/SVseq2/$FILENAME.deletion.res
/home/y/ywang1/soft/SVseq2/SVseq2_2 -insertion  -b /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/228.bam.list -c $FILENAME --o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/SVseq2/$FILENAME.insertion.res




FILES=`cat chr.list`
# get size of array
NUMFASTQ=${#FILES[@]}
# now subtract 1 as we have to use zero-based indexing (first cell is 0)
ZBNUMFASTQ=$(($NUMFASTQ - 1))
# now submit to SLURM
if [ $ZBNUMFASTQ -ge 0 ]; then
	echo "start with $ZBNUMFASTQ"
	sbatch --array=0-$ZBNUMFASTQ SVseq2_array.sbatch
fi


perl /home/y/ywang1/soft/softsearch/src/SoftSearch.pl -f /scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta -b /scratch/tmp/xus/SP_pangenome/BAM_RMDP/SP165.rmdp.bam