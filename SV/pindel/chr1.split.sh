#! /bin/bash
# pindel.jas.merge.ChrS01.1.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=24        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.jas.merge.ChrS01.1    # the name of your job
#SBATCH -o pindel.jas.merge.ChrS01.1.out # Standard output
#SBATCH -e pindel.jas.merge.ChrS01.1.err # Standard error

module load palma/2020b Miniconda3/4.9.2
source activate jas_env

/home/y/ywang1/.conda/envs/jas_env/bin/jasmine \
--allow_intrasample --output_genotypes threads=20 max_dist=500 k_jaccard=8 min_seq_id=0.25 \
file_list=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/per_chr_merge/ChrS01/split/1/vcf.list \
out_file=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/per_chr_merge/ChrS01/split/1/pindel.ChrS01.jas.merged.1.vcf






#! /bin/bash
# pindel.jas.merge.ChrS01.2.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=24        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.jas.merge.ChrS01.2    # the name of your job
#SBATCH -o pindel.jas.merge.ChrS01.2.out # Standard output
#SBATCH -e pindel.jas.merge.ChrS01.2.err # Standard error

module load palma/2020b Miniconda3/4.9.2
source activate jas_env

/home/y/ywang1/.conda/envs/jas_env/bin/jasmine \
--allow_intrasample --output_genotypes threads=20 max_dist=500 k_jaccard=8 min_seq_id=0.25 \
file_list=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/per_chr_merge/ChrS01/split/2/vcf.list \
out_file=/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Pindel/per_chr_merge/ChrS01/split/2/pindel.ChrS01.jas.merged.2.vcf