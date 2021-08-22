#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;

my $dir="/home/y/ywang1/scr/01.duckweed/popgenomics/SV/Pindel/per_chr_merge/";
my $head="$dir/header/";
`mkdir -p $head`;

my @chr;
open CHR, "</scratch/tmp/ywang1/01.duckweed/popgenomics/SV/Breakdancer/sep_chr/chr.list";
while (<CHR>){
	chomp;
	my $c=$_;
	push @chr,$c;
	`mkdir -p "$dir/$c"`;
	if (-e "$dir/$c/tmp.$c.vcf.list"){
		`rm "$dir/$c/tmp.$c.vcf.list"`;
	} 
}
close CHR;

#open LIST, "<$dir/test.list";
open LIST, "<$dir/vcf.list";
while (<LIST>){
	chomp;
	my $vcf=$_;
	my $filename = basename($vcf, ".all.nuc_nopseudo.vcf");
	`grep "#" $vcf > $head/$filename.head`;

	for my $c (@chr){
		open VLIST, ">>$dir/$c/tmp.$c.vcf.list";
		`grep $c $vcf > $dir/$c/$filename.$c.tmp`;
		`cat $head/$filename.head $dir/$c/$filename.$c.tmp > $dir/$c/$filename.$c.vcf`;
		`rm $dir/$c/$filename.$c.tmp`;

		print VLIST "$dir/$c/$filename.$c.vcf\n";
		close VLIST;
	}
}
close LIST;

open ALL, ">$dir/jas.merge.all.sbatch.sh";
for my $c (@chr){
	my $out=print_jasmin($c,$dir);
	open SUB, ">$dir/$c/pindel.jas.merge.$c.sbatch";
	print SUB "$out\n";
	close SUB;
	print ALL "cd $dir/; sbatch $dir/$c/pindel.jas.merge.$c.sbatch\n";
}
close ALL;

sub print_jasmin{
	#$_[0]; #chr
	#$_[1]; #filename
	#$_[2]; #dir_path
	my ($c,$dir)=@_;
	my $out="#! /bin/bash
# pindel.jas.merge.$c.sbatch

#SBATCH --export=ALL               # Start with a clean environment
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=24        # the number of CPU cores per node
#SBATCH --mem=56G                 # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=48:00:00             # the max wallclock time (time limit your job will run)
#SBATCH --job-name=pindel.jas.merge.$c    # the name of your job
#SBATCH -o pindel.jas.merge.$c.out # Standard output
#SBATCH -e pindel.jas.merge.$c.err # Standard error

module load palma/2020b Miniconda3/4.9.2
source activate jas_env

/home/y/ywang1/.conda/envs/jas_env/bin/jasmine \\
--allow_intrasample --output_genotypes threads=20 max_dist=500 k_jaccard=8 min_seq_id=0.25 \\
file_list=$dir/$c/tmp.$c.vcf.list \\
out_file=$dir/$c/pindel.$c.jas.merged.vcf\n";
	return $out;

}