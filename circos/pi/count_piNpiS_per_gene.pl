#! /usr/bin/perl

use strict;
use warnings;

die "file? perl $0 site_res_file(SNPgenie)_list\n" if (@ARGV==0);

my $list=$ARGV[0];

open LIST, "<$list";
# file    product site    ref_nt  maj_nt  position_in_codon       overlapping_ORFs        codon_start_site        codon   pi      gdiv    class_vs_ref    class   coverage        A       C       G       T
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669368 C       C       3       0       2669366 GGC     0.0260266049739734       0.0259695290858726      Synonymous      Synonymous      456     0       450     0       6
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669501 G       A       1       0       2669501 GTG     0.47888953152111	0.477839335180055        Nonsynonymous   Nonsynonymous   456     276     0       180     0
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669528 C       C       1       0       2669528 CTG     0.0555137844611529       0.0553920437057558      Synonymous      Synonymous      456     0       443     0       13
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669549 G       G       1       0       2669549 GCC     0.0637651821862348       0.063625346260388       Nonsynonymous   Nonsynonymous   456     15      0       441     0
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0001200 2607507 G       G       3       0       2607505 TCG     0.0217370348949297       0.0216893659587567      Synonymous      Synonymous      456     5.00000000000002        0       451     0
# ChrS01.vcf.AF_corrected.vcf    noncoding       179970  T       G       NA      0       NA      NA      0.369144013880856	0.368334487534626       noncoding       noncoding       456     0       0       345     111
# ChrS01.vcf.AF_corrected.vcf    noncoding       179975  C       C       NA      0       NA      NA      0.174744553691922	0.17436134195137        noncoding       noncoding       456     0       412     0       44


my %pi;
while(<LIST>){
	chomp;
	open IN, "<$_";
	while (<IN>){
		chomp;
		next if (/^file\tproduct\tsite/);
		my @a=split/\t/,$_;
		#push @{$hash{$a[2]}},($a[9],$a[11]);
		if ($a[11] eq "Nonsynonymous"){
			$pi{$a[1]}{"piN"}+=$a[9];
		} elsif ($a[11] eq "Synonymous"){
			$pi{$a[1]}{"piS"}+=$a[9];
		}
	}
	 close IN;

}
close LIST;

my %piNpiS;

for my $gene (keys %pi){
	if (! exists $pi{$gene}{"piN"} ){
		$piNpiS{$gene}=0;
		next;
	}
	if (! exists $pi{$gene}{"piS"} ){
		$piNpiS{$gene}=0;
		next;
	}
	if ($pi{$gene}{"piN"}==0 or $pi{$gene}{"piS"}==0){
		$piNpiS{$gene}=0;
		next;
	}
	$piNpiS{$gene}=$pi{$gene}{"piN"}/$pi{$gene}{"piS"};
}	


for my $gene (sort {$piNpiS{$b} <=> $piNpiS{$a}} keys %pi){
	print "$gene\t$piNpiS{$gene}\n";
}

__END__
#/home/wangyz/sciebo/PopulationGenomics_duckweed/circos_plot/pi/SNPgenie.res_cp
./count_piNpiS_per_gene.pl site_results.list > piNpiS_per_gene.out
