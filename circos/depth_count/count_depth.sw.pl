#! /usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;
use File::Basename;

die ("file? perl $0 <fasta file> <depth file> <win size [100k]> <step size [10k]>\n") if (@ARGV==0);

my $fa = $ARGV[0];
my $dp= $ARGV[1];
my $win = $ARGV[2] || 100000;
my $step =  $ARGV[3] || 10000;

die "Error: window size and step size pars are not int.\n perl $0 <fasta file> <depth file> <win size [100k]> <step size [10k]>\n" if ($win!~ /^\d+$/ || $step!~ /^\d+$/);

dealing_with_dp_f($dp);

my($filename,$directories,$suffix)=fileparse($fa);
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


`bedtools intersect -wa -wb -a $filename.sw$win.step$step.bed -b $dp.bed > $dp.bed.intersect`;
# ChrS01  440000  540000  ChrS01  446064  446065  0.295623674571043
# ChrS01  440000  540000  ChrS01  446275  446276  0.295623674571043


open ITSCT, "<$dp.bed.intersect" || die "$!: can not open file $dp.bed.intersect\n";
my %dp;
while (<ITSCT>){
	chomp;
	my @a=split/\t/,$_;
	my $o=int(($a[1]+$a[2])/2);
	$dp{$a[0]}{$o}+=$a[-1];
}
close ITSCT;


open CIR_SCATTER, ">$filename.depth.sw$win.step$step.cir_scatter";
#open CIR_HISTO, ">$filename.depth.sw$win.step$step.cir_histo";
#open CIR_HEAT, ">$filename.depth.sw$win.step$step.cir_heat";

# ChrS01  6340000 6440000 30
# ChrS01  6350000 6450000 30
# ChrS01  6360000 6460000 32
for my $chr(sort {$a cmp $b} keys %dp){
	for my $pos (sort {$a<=>$b} keys %{$dp{$chr}}){
		my $av_dp=$dp{$chr}{$pos}/$win;
		print CIR_SCATTER "$chr\t$pos\t$pos\t$av_dp\n";
	}
}

close CIR_SCATTER;
#close CIR_HISTO;
#close CIR_HEAT;

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


sub dealing_with_dp_f{ 
#chr 	pos 	all_dp_count 	average_dp 	is_callable
#JN160603.2      33      660164  2895.45614035088        fail
#JN160603.2      34      659814  2893.92105263158        fail
#JN160603.2      35      661379  2900.7850877193 fail
#JN160603.2      36      662247  2904.59210526316        fail
	my $dp=$_[0];
	#my $win=$_[1];
	#my $step=$_[2];
	#print "$len,$win,$step\n";
	open DP, "<$dp" || die "Can not open depth file\n";
	open DP_BED, ">$dp.bed";

	while (<DP>){
		chomp;
		
		my @a=split/\t/,$_;
		if (@a!=5){
			print "wrong info from dp file: @a\n";
			next;
		}
		my $start=$a[1]-1;
		print DP_BED "$a[0]\t$start\t$a[1]\t$a[3]\n";
	}

	close DP;
	close DP_BED;

}


__END__
./count_depth.sw.pl ../ref/SP2.0.fa  all.callable.res
./count_depth.sw.pl ../ref/SP2.0.fa  thinning/all.callable.res.simplified
