#! /usr/bin/perl

use strict;
use warnings;

die "file? perl $0 fasta\n" if (@ARGV==0);
open FA, "<$ARGV[0]";

my %hash;
my $substr_len=100000; #cut string into 10k substrs
my $ID;

while (<FA>){
	chomp;
	if (/^>(.*)$/){
		$ID=$1;
		$hash{$ID}="";
	next;

	} else {
		$hash{$ID}.=$_;
	}
}
close FA;

open OUT, ">$ARGV[0].N_count.bins.res";

for my $chr (sort {$a cmp $b} keys %hash){
	#my @substr = $hash{$chr} =~ /\w{1,$substr_len}/g;
	my @substr = unpack("(A$substr_len)*", $hash{$chr});
	for my $i (0..$#substr){
		my $count = () = $substr[$i] =~ /\Qn/ig;
		$count=$count/$substr_len;
		my $start=$i * $substr_len;
		print OUT "$chr\t$start\t$count\n";
	}
}
close OUT;


__END__
#check whether it works
work dir: /home/wangyz/sciebo/PopulationGenomics_duckweed/circos_plot/ref
./fasta.count_N.pl SP2.0.fa

awk '{if($3>0.8){print }}' SP2.0.fa.N_count.bins.res | grep ChrS20
cat > test.bed
ChrS20	2940000	2950000


bedtools getfasta -fi SP2.0.fa -bed test.bed