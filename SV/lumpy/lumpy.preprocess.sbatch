#! /bin/bash
# lumpy.preprocess.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=8:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=lumpy.preprocess       # the name of your job
#SBATCH -o lumpy.preprocess_%A_%a.out # Standard output
#SBATCH -e lumpy.preprocess_%A_%a.err # Standard error


module load  palma/2020b  GCC/10.2.0 SAMtools/1.11

FILES=($(cat sort.bam.list))
i=${FILES[$SLURM_ARRAY_TASK_ID]}
j=$(basename $i .bam)
k=${j%.*} 
FILENAME=$(basename $k .bam)

echo "$FILENAME"
echo "$SLURM_ARRAY_TASK_ID"

# Extract the discordant paired-end alignments.
samtools view -b -F 1294 $i > $FILENAME.discordants.unsorted.bam

# Extract the split-read alignments
samtools view -h $i \
    | /home/y/ywang1/soft/lumpy-sv/scripts/extractSplitReads_BwaMem -i stdin \
    | samtools view -Sb - \
    > $FILENAME.splitters.unsorted.bam

# Sort both alignments
samtools sort $FILENAME.discordants.unsorted.bam -o $FILENAME.discordants.bam
samtools sort $FILENAME.splitters.unsorted.bam -o $FILENAME.splitters.bam

# remove intermediate files
rm $FILENAME.discordants.unsorted.bam $FILENAME.splitters.unsorted.bam





