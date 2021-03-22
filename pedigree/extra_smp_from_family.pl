#! /usr/bin/perl

use warnings;
use strict;

die "file? perl $0 file.imiss family.info\n" if (@ARGV==0);

open MISS, "<$ARGV[0]";
# INDV    N_DATA  N_GENOTYPES_FILTERED    N_MISS  F_MISS
# CC3_3   1241981 0       4114    0.00331245
# CC4_1   1241981 0       3066    0.00246864
# DD7     1241981 0       5159    0.00415385
# GP14    1241981 0       5408    0.00435433
my %mis;

while (<MISS>){
	chomp;
	next if (/^INDV\tN_DATA/);
	my @a=split/\t/,$_;

	$mis{uc($a[0])}=$a[-1];
}
close MISS;

open FAM, "<$ARGV[1]";
# Family_ID       Sample_ID       Population      Colour
# 0       CC3_3   AME     #F7931E
# 0       CC4_1   AME     #F7931E
# 0       RC1_1   AME     #F7931E
# 0       RC2_3   AME     #F7931E
# 1       GP2_3   AME     #F7931E
my %fam;
while (<FAM>){
	chomp;
	next if (/^Family_ID\tSample_ID/);
	my @a=split/\t/,$_;
	$fam{$a[0]}{$a[1]}=0;
}

close FAM;

my %out;
for my $f (keys %fam){
	my @tmp=keys %{$fam{$f}};
	my $lessmis=$tmp[0];
	for my $s (@tmp){
		if ($mis{$lessmis} > $mis{$s}){
			print"$lessmis\t$s\n$mis{$lessmis} > $mis{$s}\n";
			$lessmis=$s;
		}
	}
	$out{$f}=$lessmis;
}

open OUT, ">least_missingness_samp.list";
for my $f (sort {$a<=>$b} keys %fam){
	print OUT "$f\t$out{$f}\n";
}
close OUT;


