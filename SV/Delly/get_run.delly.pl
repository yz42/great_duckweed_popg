#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);

my $path=`pwd`;
chomp $path;
`mkdir -p $path/delly_Res`;

open LIST, "<$ARGV[0]";
open CALL_ALL, ">$path/delly_Res/01.delly_run.all.sh";

open MERGE, ">$path/delly_Res/02.delly_merge.sh";

open GENOTYPING, ">$path/delly_Res/03.genotyping.sh";

print MERGE "#! /bin/bash

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=20G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=delly_merge       # the name of your job
#SBATCH --output=delly_merge.output.dat         # the file where output is written to (stdout & stderr)

module load palma/2020b  libevent/2.1.12  libpng/1.6.37  libdrm/2.4.102  GLib/2.66.1  cURL/7.72.0  JasPer/2.0.14   GCCcore/10.2.0 OpenMPI/4.0.5  UCX/1.9.0  freetype/2.10.3  libglvnd/1.3.2  cairo/1.16.0  GMP/6.2.0  LittleCMS/2.11  M4/1.4.18  zlib/1.2.11  libfabric/1.11.0  ncurses/6.2  libunwind/1.4.0  libreadline/8.0  NLopt/2.6.2  ImageMagick/7.0.10-35  Autoconf/2.69  binutils/2.35  PMIx/3.1.5  util-linux/2.36  LLVM/11.0.0  Tcl/8.6.10  libsndfile/1.0.28  GLPK/4.65  Automake/1.16.2  GCC/10.2.0  OpenMPI/4.0.5  fontconfig/2.13.92  Mesa/20.2.1  SQLite/3.33.0  ICU/67.1  nodejs/12.19.0  libtool/2.4.6  numactl/2.0.13  OpenBLAS/0.3.12  xorg-macros/1.19.2  libGLU/9.0.1  PCRE2/10.35  Szip/2.1.1  iccifort/2020.4.304  Autotools/20200321  XZ/5.2.5  FFTW/3.3.8  X11/20201008  pixman/0.40.0  NASM/2.15.05  HDF5/1.10.7  impi/2019.9.304  HTSlib/1.11  libxml2/2.9.10  ScaLAPACK/2.1.0  gzip/1.10  libffi/3.3  libjpeg-turbo/2.0.5  UDUNITS/2.2.26  imkl/2020.4.304  Boost/1.74.0  libpciaccess/0.16  bzip2/1.0.8  lz4/1.9.2  gettext/0.21  LibTIFF/4.1.0  GSL/2.6  intel/2020b  hwloc/2.2.0  expat/2.2.9  zstd/1.4.5  PCRE/8.44  Tk/8.6.10  Ghostscript/9.53.3  Java/11.0.2  R/4.0.3

/home/y/ywang1/soft/Delly/delly/src/delly merge -o $path/delly_Res/228.all.delly_merge.sites.bcf ";



while (<LIST>){
        chomp;
        my $bam=$_;
        my($filename,$directories,$suffix)=fileparse($bam);
        open OUT1, ">$path/delly_Res/$filename.delly_call.sh";
        print  OUT1 "#! /bin/bash

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=$filename.delly       # the name of your job
#SBATCH --output=$filename.delly.output.dat         # the file where output is written to (stdout & stderr)

module load palma/2020b  libevent/2.1.12  libpng/1.6.37  libdrm/2.4.102  GLib/2.66.1  cURL/7.72.0  JasPer/2.0.14   GCCcore/10.2.0 OpenMPI/4.0.5  UCX/1.9.0  freetype/2.10.3  libglvnd/1.3.2  cairo/1.16.0  GMP/6.2.0  LittleCMS/2.11  M4/1.4.18  zlib/1.2.11  libfabric/1.11.0  ncurses/6.2  libunwind/1.4.0  libreadline/8.0  NLopt/2.6.2  ImageMagick/7.0.10-35  Autoconf/2.69  binutils/2.35  PMIx/3.1.5  util-linux/2.36  LLVM/11.0.0  Tcl/8.6.10  libsndfile/1.0.28  GLPK/4.65  Automake/1.16.2  GCC/10.2.0  OpenMPI/4.0.5  fontconfig/2.13.92  Mesa/20.2.1  SQLite/3.33.0  ICU/67.1  nodejs/12.19.0  libtool/2.4.6  numactl/2.0.13  OpenBLAS/0.3.12  xorg-macros/1.19.2  libGLU/9.0.1  PCRE2/10.35  Szip/2.1.1  iccifort/2020.4.304  Autotools/20200321  XZ/5.2.5  FFTW/3.3.8  X11/20201008  pixman/0.40.0  NASM/2.15.05  HDF5/1.10.7  impi/2019.9.304  HTSlib/1.11  libxml2/2.9.10  ScaLAPACK/2.1.0  gzip/1.10  libffi/3.3  libjpeg-turbo/2.0.5  UDUNITS/2.2.26  imkl/2020.4.304  Boost/1.74.0  libpciaccess/0.16  bzip2/1.0.8  lz4/1.9.2  gettext/0.21  LibTIFF/4.1.0  GSL/2.6  intel/2020b  hwloc/2.2.0  expat/2.2.9  zstd/1.4.5  PCRE/8.44  Tk/8.6.10  Ghostscript/9.53.3  Java/11.0.2  R/4.0.3

/home/y/ywang1/soft/Delly/delly/src/delly call -g /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta -o $path/delly_Res/$filename.bcf $bam\n";
        close OUT1;

        print CALL_ALL "sbatch $path/delly_Res/$filename.delly_call.sh\n";
        print MERGE " $path/delly_Res/$filename.bcf ";

        open OUT2, ">$path/delly_Res/$filename.delly_genotyping.sh";
        print  OUT2 "#! /bin/bash

#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=2        # the number of CPU cores per node
#SBATCH --mem=8G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=$filename.delly       # the name of your job
#SBATCH --output=$filename.delly.output.dat         # the file where output is written to (stdout & stderr)

module load palma/2020b  libevent/2.1.12  libpng/1.6.37  libdrm/2.4.102  GLib/2.66.1  cURL/7.72.0  JasPer/2.0.14   GCCcore/10.2.0 OpenMPI/4.0.5  UCX/1.9.0  freetype/2.10.3  libglvnd/1.3.2  cairo/1.16.0  GMP/6.2.0  LittleCMS/2.11  M4/1.4.18  zlib/1.2.11  libfabric/1.11.0  ncurses/6.2  libunwind/1.4.0  libreadline/8.0  NLopt/2.6.2  ImageMagick/7.0.10-35  Autoconf/2.69  binutils/2.35  PMIx/3.1.5  util-linux/2.36  LLVM/11.0.0  Tcl/8.6.10  libsndfile/1.0.28  GLPK/4.65  Automake/1.16.2  GCC/10.2.0  OpenMPI/4.0.5  fontconfig/2.13.92  Mesa/20.2.1  SQLite/3.33.0  ICU/67.1  nodejs/12.19.0  libtool/2.4.6  numactl/2.0.13  OpenBLAS/0.3.12  xorg-macros/1.19.2  libGLU/9.0.1  PCRE2/10.35  Szip/2.1.1  iccifort/2020.4.304  Autotools/20200321  XZ/5.2.5  FFTW/3.3.8  X11/20201008  pixman/0.40.0  NASM/2.15.05  HDF5/1.10.7  impi/2019.9.304  HTSlib/1.11  libxml2/2.9.10  ScaLAPACK/2.1.0  gzip/1.10  libffi/3.3  libjpeg-turbo/2.0.5  UDUNITS/2.2.26  imkl/2020.4.304  Boost/1.74.0  libpciaccess/0.16  bzip2/1.0.8  lz4/1.9.2  gettext/0.21  LibTIFF/4.1.0  GSL/2.6  intel/2020b  hwloc/2.2.0  expat/2.2.9  zstd/1.4.5  PCRE/8.44  Tk/8.6.10  Ghostscript/9.53.3  Java/11.0.2  R/4.0.3

/home/y/ywang1/soft/Delly/delly/src/delly call -g /scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP_combined.fasta  -v $path/delly_Res/228.all.delly_merge.sites.bcf -o $path/delly_Res/$filename.geno.bcf $bam\n";
        close OUT2;
        print GENOTYPING "sbatch $path/delly_Res/$filename.delly_genotyping.sh\n";

}

print MERGE "\n";

close LIST;
close GENOTYPING;
close CALL_ALL;
close MERGE;
