FILES=($(cat sort.bam.list))
# get size of array
NUMFASTQ=${#FILES[@]}
# now subtract 1 as we have to use zero-based indexing (first cell is 0)
ZBNUMFASTQ=$(($NUMFASTQ - 1))
# now submit to SLURM
if [ $ZBNUMFASTQ -ge 0 ]; then
	echo "start with $ZBNUMFASTQ"
	sbatch --array=0-$ZBNUMFASTQ lumpy.preprocess.sbatch
fi