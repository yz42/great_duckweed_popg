#! /usr/bin/perl

use strict;
use warnings;
use File::Basename;

die "file?\n" if (@ARGV==0);


open VCF, "<$ARGV[0]";
# #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  /scratch/tmp/ywang1/01.duckweed/popgenomics/SV/3rd_ONT/ERR2683113/Sp_ONT.QC.sort.bam
# ChrS01  58658   224     CCTCTCTCTCTCTCTATCTGTGTGGAATTGTGGGAATTTTCTTCATCTTTGTCCGTGGTCTCCACATGATGAGGCATGCATGTGGGCATTNNNNNNNNNNNNNNNNNNNNTCTCTCTCTCT       N       .       PASS    PRECISE;SVMETHOD=Snifflesv1.0.12;CHR2=ChrS01;END=58779;STD_quant_start=0.000000;STD_quant_stop=1.658312;Kurtosis_quant_start=0.553342;Kurtosis_quant_stop=7.197928;SVTYPE=DEL;SUPTYPE=AL;SVLEN=-121;STRANDS=+-;STRANDS2=17,8,17,8;RE=25;REF_strand18,8;Strandbias_pval=1;AF=0.490196     GT:DR:DV        0/1:26:25
# ChrS01  121927  225     TAGNNNNNNNNNNNNNNNNNNNNAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAG       N       .       PASS    IMPRECISE;SVMETHOD=Snifflesv1.0.1;CHR2=ChrS01;END=122052;STD_quant_start=16.009372;STD_quant_stop=12.340989;Kurtosis_quant_start=-0.220187;Kurtosis_quant_stop=-0.029123;SVTYPE=DEL;SUPTYPE=AL;SVLEN=-125;STRANDS=+-;STRANDS2=7,10,7,10;RE=17;REFstrand=7,11;Strandbias_pval=1;AF=0.485714      GT:DR:DV        0/1:18:17
# ChrS01  124870  226     GGAGGGGGGGGGGGGGGGAGAGAGAGAGAGATAAACTGANNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN    N       .       PASS    PRECISE;SVMETHOD=Snifflesv1.0.12;CHR2=ChrS01;END=125065;STD_quant_start=1.760682;STD_quant_stop=4.743416;Kurtosis_quant_start=0.102651;Kurtosis_quant_stop=-1.487938;SVTYPE=DEL;SPTYPE=AL;SVLEN=-195;STRANDS=+-;STRANDS2=7,10,7,10;RE=17;REF_strand=7,10;Strandbias_pval=1;AF=0.5       GT:DR:DV        0/1:17:17

my %hash;
open OUT, ">$ARGV[0].rm_Ns.vcf";
while (<VCF>){
	chomp;
	if (/^#/){
		print OUT "$_\n";
	}
	my @a=split/\s+/,$_;
	my $ref_seq=$a[3];
	my $Ns=$ref_seq=~tr/N/N/;
	my $len=length($ref_seq);
	
	my $type=$1 if ($_=~/SVTYPE=(\w+);/);
	$hash{$type}++;

	if (!$Ns||$len==0||$Ns==1){
		print OUT "$_\n";
		next;
	}
	my $Nrate=$Ns/$len;
	if ($Nrate>0.3) {
		print "$ref_seq\t$len\t$Ns\t$Nrate\n";
		$hash{$type}--;
		next;
	}
	print OUT "$_\n";

}
close VCF;
close OUT;

for my $i (keys %hash){
	print "$i\t$hash{$i}\n";
}