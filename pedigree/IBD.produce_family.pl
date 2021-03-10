#! /usr/bin/perl

use strict;
use warnings;

die "perl $0 \n" if (@ARGV !=1);

open LIST, "<./pop.list";
my %pop;
my %color=("AME","#F7931E", "ASIA","#FF0000","EUR" ,"#0000FF","IND","#39B54A"); #color rule

while (<LIST>){
	chomp;
	next if (/^smps/);
	my @a=split/\t/,$_;
	$pop{$a[0]}=$a[1];
}

close LIST;

# samp1   samp2   #SNP    IBD0    IBD1    IBD2
# CC3_3   CC4_1   147956  1       1619    146336
# CC3_3   DD7     147956  656     12835   134465
# CC3_3   GP14    147956  663     12761   134532
# CC3_3   GP2_3   147956  456     13167   134333

my $het_diff=0.02; #IBD1
my $hom_diff=0.0001; #IBD2

my %clone;

open IN, "<$ARGV[0]";

my $family_n=0;
A: while (<IN>){
	chomp;
	next if (/^samp1/);
	my @a=split/\t/,$_;
	my $het=$a[4]/$a[2];
	my $hom=$a[3]/$a[2];
	if ($het <=  $het_diff and $hom <=  $hom_diff){

		if (! exists $clone{"0"}){
			$clone{"0"}{$a[0]}=0;
			$clone{"0"}{$a[1]}=0;
			next A;
		}
		my $sw=0; #switch
		B: for my $f (keys %clone){
			if (exists $clone{$f}{$a[0]} or exists $clone{$f}{$a[1]}){
				 $clone{$f}{$a[0]}=0;
				 $clone{$f}{$a[1]}=0;
				 $sw=1;
				 last B;
			} 
		}
		if ($sw == 0){
			$family_n++;
			$clone{$family_n}{$a[0]}=0;
			$clone{$family_n}{$a[1]}=0;
		}
	}
}

close IN;




my %pop_r=%pop;
my $f_r=0;

my %res;

for my $f (sort {$a<=>$b} keys %clone){
	for my $s (sort {$a cmp $b} keys %{$clone{$f}}){

		$s=uc($s);
		my $p=$pop{$s};
		my $c=$color{$p};
		delete $pop_r{$s};
		$f_r=$f if  $f_r < $f;
		$res{$p}{$f}{$s}=0;

		#print OUT "$f\t$s\t$p\t$c\n";
	}
}

for my $s (sort {$a cmp $b} keys %pop_r){
	$f_r++;
	$s=uc($s);
	my $p=$pop{$s};
	my $c=$color{$p};
	$res{$p}{$f_r}{$s}=0;

}

open OUT, ">family_info.txt";
print OUT "Family_ID\tSample_ID\tPopulation\tColour\n";

for my $p ("AME","ASIA","EUR","IND"){
	for my $f (sort {$a <=> $b} keys %{$res{$p}}){
		for my $s (sort {$a cmp $b} keys %{$res{$p}{$f}}){
			my $c=$color{$p};
			print OUT "$f\t$s\t$p\t$c\n";
		}
	}
}

close OUT;

# `sort -k3 -k1n family_info`;
# `cat family_info.head family_info > family_info.txt`;
# `rm family_info.head family_info`;

__END__
/home/wangyz/sciebo/PopulationGenomics_duckweed/pedigree/count_het_hom/hom_het_count.csv
/home/wangyz/sciebo/PopulationGenomics_duckweed/pedigree/count_het_hom/pop.list