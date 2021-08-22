#index
module load  palma/2020b  GCCcore/10.2.0 GCC/10.2.0  SAMtools/1.11 Perl/5.32.0 Python/3.8.6 
 
perl  /home/y/ywang1/soft/CNVcaller/bin/CNVReferenceDB.pl /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta 1> index.out 2> index.err &




#generating duplicated window record file
module load  palma/2020b  GCCcore/10.2.0 GCC/10.2.0  SAMtools/1.11 Perl/5.32.0 Python/3.8.6 

/home/y/ywang1/.conda/envs/conda-env/bin/sawriter /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/SP_combined.fasta.sa /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta

python /home/y/ywang1/soft/CNVcaller/bin/0.1.Kmer_Generate.py /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta 800 /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/kmer.fa

/home/y/ywang1/.conda/envs/conda-env/bin/blasr  /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/kmer.fa /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta --sa /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/SP_combined.fasta.sa --out /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 --advanceHalf --advanceExactMatches 10 --fastMaxInterval --fastSDP --aggressiveIntervalCut --bestn 10

python /home/y/ywang1/soft/CNVcaller/bin/0.2.Kmer_Link.py /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/kmer.aln 800 /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/window.link



#generate per sample "Individual RD processing" submission script
perl 02.CNVcaller.calling.get_run.pl 1
sh 02.CNVcaller.calling.run_all.sh




#CNVR detection
module load  palma/2020b  GCCcore/10.2.0 GCC/10.2.0  SAMtools/1.11 Perl/5.32.0 Python/3.8.6 
bash /home/y/ywang1/soft/CNVcaller/CNV.Discovery.sh \
-l /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/RD_norm.list \
-e /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/exclude_list \
-f 0.025 -h 3 -r 0.15 -p primaryCNVR -m mergeCNVR




#Genotyping
#### CNVcaller.genotyping
#! /bin/bash
# 04.CNVcaller.genotyping.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=30        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=CNVcaller.genotyping    # the name of your job
#SBATCH -o CNVcaller.genotyping.out # Standard output
#SBATCH -e CNVcaller.genotyping.err # Standard error

module load  palma/2020b  GCCcore/10.2.0 GCC/10.2.0  SAMtools/1.11 Perl/5.32.0 Python/3.8.6 
python /home/y/ywang1/soft/CNVcaller/Genotype.py \
--nproc 24 --cnvfile /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/mergeCNVR \
--outprefix /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/CNVcaller/SP228.CNVcaller.Genotype