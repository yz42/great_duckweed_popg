#! /bin/bash
# gridss.02.calling.ASIA.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=80G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.call.ASIA      # the name of your job
#SBATCH -o gridss.call.ASIA.out # Standard output
#SBATCH -e gridss.call.ASIA.err # Standard error
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=ywang1@uni-muenster.de # your mail address

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11

/home/y/ywang1/soft/gridss/gridss \
--steps call \
--configuration gridss.properties \
-o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.ASIA.joint_calling.res.vcf.gz \
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \
-t 1 \
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \
--jvmheap 72g \
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/working \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly06.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly03.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly04.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly02.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly05.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP178.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP179.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP180.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP182.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP183.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP184.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP185.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP186.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP187.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP188.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP191.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP195.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP197.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP198.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP199.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp016.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp061.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP200.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP201.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP202.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP203.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP172.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP204.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP205.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP206.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP207.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP208.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP209.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP210.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP212.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP213.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP216.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp036.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp083.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp067.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp072.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp099.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp100.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp116.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp118.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp119.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp120.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp121.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp123.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp124.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp125.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp126.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp001.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp024.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp025.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp035.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp038.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp050.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp057.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp063.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp129.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp132.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP181.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp101.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp112.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp113.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp114.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp115.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp117.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp122.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp127.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp130.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp135.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP138.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP140.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP141.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP142.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP143.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP145.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP148.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP150.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP151.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP153.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP155.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP156.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP157.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP158.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP159.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP160.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP161.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP162.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP163.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP165.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP167.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP168.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP170.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP171.sort.bam 