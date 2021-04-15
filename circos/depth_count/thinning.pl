#! /usr/bin/perl

use strict;
use warnings;

die "file?\n" if (@ARGV==0);

my $chr=shift;
my $dp=shift;
my $interval=100;

open CHR, "<$chr";

my %chr;

while (<CHR>){
	chomp;
	$chr{$_}=0;
}
close CHR;




open  DP, "<$dp";
open DP_S, ">$dp.simplified";

my $c=0;
while (<DP>){
	chomp;
	my @a=split/\t/,$_;
	next if ! exists $chr{$a[0]};
	$c++;
	if ($c==$interval){
		my $tmp=join "\t", @a;
		print DP_S "$tmp\n";
		open DP_CHR, ">>$dp.simplified.$a[0]";
		print DP_CHR "$tmp\n";
		close DP_CHR;
		$c=0;
	} 
}
close DP;
close DP_S;


__END__


 ./thinning.pl ../chromosomes.txt  all.callable.res