#! /usr/bin/perl

use warnings;
use strict;
#use List::MoreUtils ':all';

die "file? perl $0 comp.SpGA_iso.out.cds_aed.out  comp.bk1_SpGA.out.cds_aed.out\n" if (@ARGV==0);

my $in1=shift;
my $in2=shift;
# my $de_list="remove_gene.list";
# my $de_re="remove_gene.list.reason";
# my $add_list="add_gene.list";
# my $add_re="add_gene.list.reason";

my (%de_list,%add_list,%de_add_reason,%perfect_match);

open IN1, "<$in1";
while (<IN1>){
# SpGA2022_015137-R1      G6885.1 1.000
# SpGA2022_007476-R0      G2911.1 0.367
# SpGA2022_018466-R0      G8537.3 0.446
	chomp;
	my @a=split/\t/,$_;
	my $SpGA_gene;
	if ($a[0]=~/([\w]+)\-[\w]+/){
		$SpGA_gene=$1;
	}else{
		die "$a[0] not match!\n";
	}
	my $iso_gene;
	if ($a[1]=~/([\w]+)\.[\w]+/){
		$iso_gene=$1;
	}else{
		die "$a[0] not match!\n";
	}
	my $aed=$a[2];
	
	# to decide if gene models from SpGA need to be deleted or not
	if ($aed>0){
		$de_list{$SpGA_gene}++;
		$add_list{$iso_gene}++;
		$de_add_reason{$SpGA_gene}=[$iso_gene,$aed];
	} else {
		$perfect_match{$SpGA_gene}=[$iso_gene,$aed];
	}
}
close IN1;

open IN2, "<$in2";
while (<IN2>){
# SpGA2022_018554-R0      g10319.t1       0
# SpGA2022_015753-R0      g3914.t1        1.000
# SpGA2022_013208-R0      g7378.t1        0.582
	chomp;
	my @a=split/\t/,$_;
	my $SpGA_gene;
	if ($a[0]=~/([\w]+)\-[\w]+/){
		$SpGA_gene=$1;
	}else{
		die "$a[0] not match!\n";
	}
	next unless (exists $de_list{$SpGA_gene});

	my $bk1_gene;
	if ($a[1]=~/([\w]+)\.[\w]+/){
		$bk1_gene=$1;
	}else{
		die "$a[0] not match!\n";
	}
	my $aed=$a[2];

	if ($aed<0.01 and $de_add_reason{$SpGA_gene}[1] > 0.3) {
		delete($de_list{$SpGA_gene});
		push @{$de_add_reason{$SpGA_gene}}, ($bk1_gene,$aed);
	}
}
close IN2;

`mkdir -p ./select_genemodels.out`;

open DEL_LIST, ">./select_genemodels.out/remove_gene.list";
for my $i (keys %de_list){
	print DEL_LIST "$i\n";
}
close DEL_LIST;

open ADD_LIST, ">./select_genemodels.out/add_gene.list";
for my $i (keys %add_list){
	print ADD_LIST "$i\n";
}
close ADD_LIST;

open REASON, ">./select_genemodels.out/reason_for_selection";
for my $i (keys %de_add_reason){
	my $tmp=join(",",@{$de_add_reason{$i}});
	print REASON "$i\t$tmp\n";
}
close REASON;

open PERFECT, ">./select_genemodels.out/perfect_match.list";
for my $i (keys %perfect_match){
	my $tmp=join(",",@{$perfect_match{$i}});
	print PERFECT "$i\t$tmp\n";
}
close PERFECT;