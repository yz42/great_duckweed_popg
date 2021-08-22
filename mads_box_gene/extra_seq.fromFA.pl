#! /usr/bin/perl

use strict;
use warnings;

die "file?\n" if (@ARGV==0);

open GFF, "<./Os_ref.mads_box_gene_in_SP.out.gene_list.gff";
open VER, ">./Os_ref.mads_box_gene_in_SP.out.gene_list.gff.verbose.info";
# ChrS01  MIPS_SpiroV2.0  gene    10683092        10684380        .       -       .       ID=Spipo3G0101300;Description=MADS box transcription factor 11
# ChrS02  MIPS_SpiroV2.0  gene    6833091 6833855 .       -       .       ID=Spipo1G0108300;Description=MADS-box transcription factor
# ChrS02  MIPS_SpiroV2.0  gene    6845923 6846687 .       -       .       ID=Spipo1G0108400;Description=MADS-box transcription factor
my @id;
while (<GFF>){
	chomp;
	my @a=split/\t/,$_;
	$a[8]=~/ID=(\w+);Description=(.*)$/;
	my $i=$1;
	print "test: $i\n";
	my $d=$2;
	push @id, $i;
	print VER "$i\t$d\n";
}
close GFF;
close VER;

my %hash;
open FA, "</scratch/tmp/ywang1/01.duckweed/popgenomics/ref/SP2.0.gff.protein.fa";
# >Spipo23G0044400.mrna CDS=1-717 [translate_table: standard]
# MGLRGLAPSTCYGFVLTPRNQPRRRRPANVAVGASIFADVCFQLPPGGRP
my $i;
while (<FA>){
	chomp;

	if (/^>/){
		if (/^>(\w+)\.mrna+\s/){
			$i=$1;
			next;
		} else {
			die "$_ not match\n";
		}
	}
	$hash{$i}.=$_;
}
close FA;

open OUT, ">./Os_ref.mads_box_gene_in_SP.out.gene_list.gff.faa";
for my $ID (@id){
	print "$ID\n";
	if (! exists $hash{$ID}){
		print "$ID dose not exists in fasta\n";
		next;
	}
	print OUT ">$ID\n$hash{$ID}\n";
}
close OUT;

