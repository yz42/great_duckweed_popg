#! /usr/bin/perl

#check intansv res for 5 different SV caller

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;


die "check pass, usage: perl $0 1" if (@ARGV==0);
my $path=`pwd`;
chomp $path;

my (%hash,@caller);


my $call="CNVcaller";
my $file=`ls -1 $call.ChrS*.res`;
chomp $file;
open CNVC, "<$file";



# ChrS10  801     ChrS10:801-10000        A       CN0,CN2 .       .       END=10000;SVTYPE=DUP;SILHOUETTESCORE=0.5197514567507161;CALINSKIHARABAZESCORE=962.7333651679761;LOGLIKELIHOOD=0.04447530094249404       GT:CP    0/0:1.86  
# ChrS10  14401   ChrS10:14401-21200      A       CN2     .       .       END=21200;SVTYPE=DUP;SILHOUETTESCORE=0.7474197454026087;CALINSKIHARABAZESCORE=838.5970659466542;LOGLIKELIHOOD=1.0255356206751345        GT:CP    0/0:2.16 
push @caller,$call;

while (<CNVC>){
	chomp;
	next if (/^#/);
	my @a=split/\s+/,$_;
	$a[7]=~/SVTYPE=(\w+)/;
	my $type=$1;

	my $s=0;
	if ($a[2]=~/:(\d+)\-(\d+)/){
		$s=abs($2-$1)+1;
	} else {
		print "wrong match: $. in $call file\n";
	}
	if ($s>=50 && $s<=1000000){
		if (! exists $hash{$call}{$type}){
			$hash{$call}{$type}=0;
		}
		$hash{$call}{$type}++;
	}
}
close CNVC;



$call="breakdancer";
$file=`ls -1 $call.ChrS*.res`;
chomp $file;
open BREA, "<$file";
#Chr1   Pos1    Orientation1    Chr2    Pos2    Orientation2    Type    Size    Score   num_Reads       num_Reads_lib
# ChrS10  3641    3349+1235-      ChrS10  3769    4800+2885-      DEL     209     50      221     DD7|1,NA:GP2_3|1,NA:GP4_2|1,NA:GP8_1|1,NA:HerbarG1|3,0.04:RC2_3|1,NA:RL1_1|2,NA:RL2_1|2,NA:RR2_1|1,0.26:RU-100|3,NA:RU-102
# ChrS10  31188   16450+7077-     ChrS10  58901   20496+5103-     INS     -207    97      826     SP138|3,2.24:SP140|6,2.22:SP142|35,2.52:SP143|1,2.16:SP145|2,2.49:SP148|16,2.21:SP150|1,2.26:SP153|1,2.25:SP155|6,2.31:SP157

push @caller,$call;

while (<BREA>){
	chomp;
	next if (/^#/);
	my @a=split/\s+/,$_;


	$a[6]=~/(\w+)/;
	my $type=$1;

	$a[7]=~/(\d+)/;
	my $s=abs($1);

	$a[8]=~/(\d+)/;
	my $score=abs($1);

	$a[9]=~/(\d+)/;
	my $r=abs($1);
	
	if ($s>=50 && $s<=1000000 && $score>=30 && $r>=3){
		if (! exists $hash{$call}{$type}){
			$hash{$call}{$type}=0;
		}
		$hash{$call}{$type}++;
	}
}
close BREA;




$call="delly";
$file=`ls -1 $call.ChrS*.res`;
chomp $file;
open DELLY, "<$file";
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  HerbarG1
#ChrS01  49578   DEL00000080     C       <DEL>   1020    PASS    PRECISE;SVTYPE=DEL;SVMETHOD=EMBL.DELLYv0.8.7;END=49633;PE=0;MAPQ=0;CT=3to5;CIPOS=-24,24;CIEND=-24,24;SRMAPQ=60;INSLEN=0;HOMLEN=24;SR=17;SRQ=0.994924;CONSENSUS=TTTTTTTTTCTGGTTTTCGTCTTCTGAAGATAGTTTGAGATGCTACCATTCTTTCGCTTGGTGCTTTCTTCTATATCAAATCCTCTCTCTCTCTCTCTCTCTACTCACATATCTTTGCATATATCGATCTACCTGGCTATAATCGCACTGTTGGGTGTGCCGTGCCTTCTAACATGAGTGAAAATATTTCCAGGGAG;CE=1.90212;RDRATIO=0.376991  GT:GL:GQ:FT:RCL:RC:RCR:RDCN:DR:DV:RR:RV 0/0:0,-11.1326,-134.895:111:PASS:2082:5440:1813:3:0:0:37:0      0/0:0,-5.65692,-64.8373:57:PASS:907:1910:815:2:0:0:19:0

push @caller,$call;

while (<DELLY>){
	chomp;
	next if (/^#/);
	my @a=split/\s+/,$_;
	$a[7]=~/SVTYPE=(\w+)/;
	my $type=$1;

	$a[7]=~/END=([\-\d]+)/;
	my $s=abs($1-$a[1])+1;


	$a[7]=~/;PE=(\d+)/;
	my $pe=$1;

	$a[7]=~/;SR=(\d+)/;
	my $sr=$1;

	my $r=$pe+$sr;

	if ($s>=50 && $s<=1000000 && $r>=3){
		if (! exists $hash{$call}{$type}){
			$hash{$call}{$type}=0;
		}
		$hash{$call}{$type}++;
	}
}
close DELLY;



$call="lumpy";
$file=`ls -1 $call.ChrS*.res`;
chomp $file;
open LUMPY, "<$file";

#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  CC3_3
#ChrS01  29      31209   N       <DUP>   302.38  .       SVTYPE=DUP;SVLEN=10693;END=10722;STRANDS=-+:12;IMPRECISE;CIPOS=-29,20;CIEND=-34,523;CIPOS95=-11,11;CIEND95=-34,136;SU=12;PE=12;SR=0;SNAME=Sp108:303,Sp117:353;ALG=PROD;GCF=0.236488;AN=456;AC=174        GT:GQ:SQ:GL:DP:RO:AO:QR:QA:RS:AS:ASC:RP:AP:AB:DHFC:DHFFC:DHBFC  0/1:5:6.87:-2,-1,-2:27:23:3:22:2:14:0:2:8:0:0.083:0.636364:0.875:0.777778

push @caller,$call;

while (<LUMPY>){
	chomp;
	next if (/^#/);
	my @a=split/\s+/,$_;
	$a[7]=~/SVTYPE=(\w+)/;
	my $type=$1;
	next if ($type eq "BND");

	$a[7]=~/SVLEN=([\-\d]+)/;
	my $s=abs($1);


	$a[7]=~/;SU=(\d+)/;
	my $su=$1;


	if ($s>=50 && $s<=1000000 && $su>=3){
		if (! exists $hash{$call}{$type}){
			$hash{$call}{$type}=0;
		}
		$hash{$call}{$type}++;
	}
}
close LUMPY;



$call="jasmine";
$file=`ls -1 $call.ChrS*.res`;
chomp $file;
open JAS, "<$file";

# ChrS01  33847   0_._duplicate15 T       TTCTTGGTTGA     .       PASS    END=33847;HOMLEN=0;SVLEN=10;SVTYPE=INS;STARTVARIANCE=0.000000;ENDVARIANCE=0.000000;AVG_LEN=10.000000;AVG_START=33847.000000;AVG_END=33847.000000;VARCALLS=1;ALLVARS_EXT=(.);SUPP_VEC_EXT=100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;IDLIST_EXT=._duplicate15;SUPP_EXT=1;SUPP_VEC=100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;SUPP=1;SVMETHOD=JASMINE;IDLIST=._duplicate15;INTRASAMPLE_IDLIST=._duplicate15       GT:IS:OT:OS:DV:DR       0/0:.:INS:.:0:.

push @caller,$call;

while (<JAS>){
	chomp;
	next if (/^#/);
	my @a=split/\s+/,$_;
	$a[7]=~/SVTYPE=(\w+)/;
	my $type=$1;

	$a[7]=~/AVG_LEN=([\-\d]+)/;
	my $s=abs($1);

	$a[7]=~/SUPP=(\d+)/;
	my $su=$1;


	if ($s>=50 && $s<=1000000 && $su>=3){
		if (! exists $hash{$call}{$type}){
			$hash{$call}{$type}=0;
		}
		$hash{$call}{$type}++;
	}
}
close JAS;


for my $c (@caller){
	print "$c:\n";
	for my $t ("DEL","DUP","INV","INS","BND"){
		if (exists $hash{$c}{$t}){
			my $res=$hash{$c}{$t};
			print "$t:\t$res\n";
		} else {
			print "$t:\t0\n";
		}
	}
}