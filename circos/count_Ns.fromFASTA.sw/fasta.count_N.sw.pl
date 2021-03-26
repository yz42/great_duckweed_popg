#! /usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;

die ("file? perl $0 <fasta file> <win size [100k]> <step size [10k]>\n") if (@ARGV==0);

my $fa = $ARGV[0];
my $win = $ARGV[1] ||100000;
my $step = $ARGV[2] ||10000;

open OUT, ">$ARGV[0].N_count.sliding_windows.res";

my $seqio = Bio::SeqIO->new('-file' => $fa, '-format' => 'fasta');
while(my $seqobj = $seqio->next_seq) {
    my $id  = $seqobj->display_id;
    print "$id,";
    my $seq = $seqobj->seq;
    my $len = $seqobj->length;
    my @sw=sliding_windows($len,$win,$step);
	for my $i (0..$#sw){
		my ($start,$end)=@{$sw[$i]};
		#print "$start,$end\n";
		my $subseq=$seqobj->subseq($start,$end);
		my $count = () = $subseq =~ /\Qn/ig;
		$count=$count/$win;
		my $index=int(($start+$end)/2);
		print OUT "$id\t$index\t$count\n";
	}
}

close OUT;

sub sliding_windows{ #sliding_windows($len,$win,$step)
	my $len=$_[0];
	my $win=$_[1];
	my $step=$_[2];
	print "$len,$win,$step\n";
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
#the same method from: https://nsaunders.wordpress.com/2006/10/11/sliding-windows-with-bioperl/