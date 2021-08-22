#### repeat anno with lib generated from repeatmodeler
#! /bin/bash
# 04.RM.anno_with_RMd_lib.sbatch

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=42        # the number of CPU cores per node
#SBATCH --mem=48G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=RM.anno_with_RMd_lib     # the name of your job
#SBATCH -o RM.anno_with_RMd_lib.out # Standard output
#SBATCH -e RM.anno_with_RMd_lib.err # Standard error


module load palma/2020b GCC/10.2.0 GCCcore/10.2.0 OpenMPI/4.0.5 util-linux/2.36 BLAST+/2.11.0 Boost/1.74.0 DB/18.1.40 FriBidi/1.0.10 GLib/2.66.1 GMP/6.2.0 HarfBuzz/2.6.7 ICU/67.1 LMDB/0.9.24 MAFFT/7.475-with-extensions NASM/2.15.05 PCRE/8.44 PMIx/3.1.5 Pango/1.47.0 Perl/5.32.0 UCX/1.9.0 X11/20201008 XZ/5.2.5 binutils/2.35 bzip2/1.0.8 cairo/1.16.0 expat/2.2.9 fontconfig/2.13.92 freetype/2.10.3 gettext/0.21 hwloc/2.2.0 libevent/2.1.12 libfabric/1.11.0 libffi/3.3 libjpeg-turbo/2.0.5 libpciaccess/0.16 libpng/1.6.37 libreadline/8.0 libxml2/2.9.10 ncurses/6.2 numactl/2.0.13 pixman/0.40.0 xorg-macros/1.19.2 zlib/1.2.11

/home/y/ywang1/soft/repeatMasker/RepeatMasker/RepeatMasker \
-nolow -norna -engine rmblast -parallel 10 \
-lib /scratch/tmp/ywang1/01.duckweed/popgenomics/Repeat_anno/RM_147039.MonJun281005052021/consensi.fa.classified \
-dir /scratch/tmp/ywang1/01.duckweed/popgenomics/Repeat_anno/anno_with_RMd_lib \
/scratch/tmp/xus/SP_pangenome/Refgenome/SP_combined.fasta


#### convert RepeatMasker result to gff format by RepeatMasker.repeat_to_gff.pl (lettuce2020 github)
/home/y/ywang1/soft/lettuce2020/01.genome.assembly/RepeatMasker.repeat_to_gff.pl /scratch/tmp/ywang1/01.duckweed/popgenomics/Repeat_anno/anno_with_RMd_lib/SP_combined.fasta.out