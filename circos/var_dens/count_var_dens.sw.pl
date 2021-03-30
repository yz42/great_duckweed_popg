#! /usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;
use File::Basename;

die ("file? perl $0 <fasta file> <vcf file> <out_dir> <win size [100k]> <step size [10k]>\n") if (@ARGV==0);

my $fa = $ARGV[0];
my $gff= $ARGV[1];
my $outdir= $ARGV[2] || "out_dir";
my $win = $ARGV[3] || 100000;
my $step =  $ARGV[4] || 10000;

die "Error: window size and step size pars are not int.\n perl $0 <fasta file> <vcf file> <win size [100k]> <step size [10k]>\n" if ($win!~ /^\d+$/ || $step!~ /^\d+$/);

my($filename,$directories,$suffix)=fileparse($ARGV[0]);

`mkdir -p $outdir`;
$filename="./$outdir/"."$filename";

open BED, ">$filename.sw$win.step$step.bed";
my $seqio = Bio::SeqIO->new('-file' => $fa, '-format' => 'fasta');

while (my $seqobj = $seqio->next_seq) {
	my $id  = $seqobj->display_id;
	my $seq = $seqobj->seq;
	my $len = $seqobj->length;
	my @sw=sliding_windows($len,$win,$step);
	for my $i (0..$#sw){
		my ($start,$end)=@{$sw[$i]};
		$start--;
		print BED "$id\t$start\t$end\n";
		#my $subseq=$seqobj->subseq($start,$end);
		#print "$i\t$subseq\n";
	}
}
close BED;

`bedtools intersect -c -a $filename.sw$win.step$step.bed -b $gff > $filename.sw$win.step$step.count.bed`;
`z-norm.sh $filename.sw$win.step$step.count.bed`; #thanks to: https://askubuntu.com/questions/1158577/bin-bash-bad-interpreter-no-such-file-or-directory


open ZN, "<$filename.sw$win.step$step.count.bed.z-norm";
my @z;
while (<ZN>){
	chomp;
	my @a=split/\s+/,$_;
	push @z,$a[1];
}
close ZN;

open OUTBED, "<$filename.sw$win.step$step.count.bed" || die "$!: can not open file $filename.sw$win.step$step.count.bed\n";
open CIR_SCATTER, ">$filename.sw$win.step$step.cir_scatter";
open CIR_HISTO, ">$filename.sw$win.step$step.cir_histo";
open CIR_HEAT, ">$filename.sw$win.step$step.cir_heat";

# ChrS01  6340000 6440000 30
# ChrS01  6350000 6450000 30
# ChrS01  6360000 6460000 32
my $i=0;
while (<OUTBED>){
	chomp;
	my @a=split/\t/,$_;
	my $o=int(($a[1]+$a[2])/2);
	my $st=$o-($step/2);
	my $en=$o+($step/2)-1;
	print CIR_SCATTER "$a[0]\t$o\t$o\t$a[3]\n";
	print CIR_HISTO "$a[0]\t$st\t$en\t$a[3]\n";
	print CIR_HEAT "$a[0]\t$st\t$en\t$z[$i]\n";
	$i++;
}
close OUTBED;
close CIR_SCATTER;
close CIR_HISTO;
close CIR_HEAT;

sub sliding_windows{ #sliding_windows($len,$win,$step)
	my $len=$_[0];
	my $win=$_[1];
	my $step=$_[2];
	#print "$len,$win,$step\n";
	die "Error: window size is larger than the sequence length.\n" if ($win > $len);
	my @out;

	for (my $i=0; $i*$step+$win<=$len; $i++){
		my $start=$i*$step+1;
		my $end=$start+$win-1;
		if ($end > $len){
			$end=$len;
		}
		push @out, [$start,$end];
	}
	return @out;
}

__END__
./count_var_dens.sw.pl ../ref/SP2.0.fa  SP_228.basic_set.indel.recode.vcf