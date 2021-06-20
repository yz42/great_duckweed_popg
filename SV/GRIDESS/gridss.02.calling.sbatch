#! /bin/bash
# gridss.02.calling.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=20        # the number of CPU cores per node
#SBATCH --mem=64G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=72:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=gridss.call       # the name of your job
#SBATCH -o gridss.call.out # Standard output
#SBATCH -e gridss.call.err # Standard error
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=ywang1@uni-muenster.de # your mail address

module load palma/2020b Java/11.0.2 GCC/10.2.0  OpenMPI/4.0.5 R/4.0.3 SAMtools/1.11

/home/y/ywang1/soft/gridss/gridss \
--steps call \
-o /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.228.joint_calling.res.vcf.gz \
-r /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta \
-t 16 \
-j /home/y/ywang1/soft/gridss/gridss-2.12.0-gridss-jar-with-dependencies.jar \
--jvmheap 48g \
--workingdir /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/working \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly06.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly03.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly04.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly02.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly09.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly07.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly11.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly10.bam \
-a /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/GRIDESS/gridss.assembly08.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/HerbarG1.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/HerbarG2.bam \
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
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP171.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP172.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP177.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP178.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP179.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP180.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP181.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP182.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP183.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP184.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP185.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP186.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP187.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP188.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP189.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP190.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP191.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP192.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP193.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP194.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP195.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP197.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP198.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP199.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP200.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP201.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP202.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP203.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP204.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP205.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP206.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP207.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP208.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP209.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP210.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP212.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP213.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP214.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP215.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP216.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP217.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP218.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP219.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP220.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP221.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP222.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP223.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP224.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP225.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP226.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP227.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP228.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP229.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP230.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP231.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP232.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP233.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP234.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP235.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP236.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP237.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP238.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP239.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP240.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/SP241.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp001.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp004.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp005.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp007.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp008.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp009.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp010.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp011.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp012.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp013.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp014.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp015.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp016.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp017.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp018.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp019.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp020.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp021.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp022.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp023.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp024.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp025.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp026.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp027.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp029.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp030.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp031.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp032.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp034.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp035.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp036.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp037.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp038.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp039.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp040.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp041.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp042.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp043.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp044.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp045.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp046.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp047.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp048.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp049.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp050.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp051.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp053.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp054.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp055.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp056.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp057.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp058.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp059.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp060.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp061.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp062.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp063.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp065.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp066.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp067.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp070.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp071.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp072.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp074.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp077.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp078.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp079.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp082.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp083.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp085.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp087.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp089.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp092.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp093.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp094.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp099.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp100.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp101.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp102.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp103.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp104.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp105.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp106.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp108.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp112.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp113.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp114.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp115.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp116.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp117.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp118.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp119.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp120.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp121.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp122.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp123.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp124.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp125.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp126.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp127.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp129.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp130.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp131.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp132.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp133.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp134.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp135.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp136.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Sp137.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-CC3_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-CC4_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-DD7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP14.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP2_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP4_2.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP6_5.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-GP8_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-HFA10.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-HFA11.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-ML1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-ML3_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB2_7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RB3_7.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RC1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RC2_3.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RD24.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RL1_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RL2_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RR2_1.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-100.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-102.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-103.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-186.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-195.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-206.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-408.bam.sort.bam \
/scratch/tmp/ywang1/01.duckweed/popgenomics/SV/deal_sortBam/bam/Toronto-RU-410.bam.sort.bam 