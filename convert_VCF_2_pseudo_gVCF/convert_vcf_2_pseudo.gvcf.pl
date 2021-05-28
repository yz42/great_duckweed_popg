#! /usr/bin/perl

use strict;
use warnings;
#use Bio::SeqIO;
use File::Basename;
use Getopt::Long; 
use Smart::Comments;

die "necessary parameters?\n" if (@ARGV==0);

my ( $ref,$vcf,$chr); 


GetOptions( 
        'ref=s'     => \$ref, 
        'vcf=s'     => \$vcf, 
        'chr=s'     => \$chr, 
); 

die "Please specify which chr|s to convert\n" if (! defined $chr); 

chomp($chr);

my %ref;


open FA, "<$ref" || die "$!: Error, cannot open file $ref\n";
my $chr_id;
my $sw=0;

if ($chr=~/all/i){
	while (<FA>){
		chomp;
		if (/^>(\w)$/){
			$chr_id=$1;
			next;
		}
		$ref{$chr_id}.=$_;
	}
} else {
	while (<FA>){
		chomp;
		if (/^>(\w+)$/ && $1 eq $chr){
			$chr_id=$1;
			$sw=1;
			next;
		} elsif (/^>(\w+)$/ &&  $1 ne $chr) {
			$sw=0;
			next;
		} else {
			if ($sw==1) {
				$ref{$chr_id}.=$_;
			}
		}
	}
}

close FA;

die "The specified chr|s do not match the IDs from the ref file\n" if (keys %ref ==0);

#`mkdir -p ./split_vcf_tmp`;

open VCF, "<$vcf" || die "$!: Error, cannot open file $vcf\n";
my($filename,$directories,$suffix)=fileparse($vcf);

# for my $i (keys %chr){
# 	my $split_vcf="./split_vcf_tmp/$filename.$i.split.vcf";
# }



my @comments;
my @smp;
my %vcf_rec;
while (<VCF>){
	chomp;
	if (/^#CHROM/){
		@smp=split/\s+/,$_;
	}
	if (/^#/){
		push @comments, $_;
		next;
	} 
	my @a=split/\t/,$_;
	next  if ($a[0] ne $chr);
	$vcf_rec{$a[0]}{$a[1]}=\@a;
}

# GT:AD:DP:GQ:PL   0/0:13,0:13:36:0,36,540
##CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  CC3_3   CC4_1   DD7     GP14    GP2_3   GP4_2   GP6_5   GP8_1   HFA10   HFA11   HerbarG1        HerbarG2        ML1_1   ML3_1   RB1_1   RB2_7    RB3_7   RC1_1   RC2_3   RD24    RL1_1   RL2_1   RR2_1   RU-100  RU-102  RU-103  RU-186  RU-195  RU-206  RU-408  RU-410  SP138   SP140   SP141   SP142   SP143   SP145   SP148   SP150   SP151   SP153   SP155    SP156   SP157   SP158   SP159   SP160   SP161   SP162   SP163   SP165   SP167   SP168   SP170   SP171   SP172   SP177   SP178   SP179   SP180   SP181   SP182   SP183   SP184   SP185   SP186   SP187   SP188    SP189   SP190   SP191   SP192   SP193   SP194   SP195   SP197   SP198   SP199   SP200   SP201   SP202   SP203   SP204   SP205   SP206   SP207   SP208   SP209   SP210   SP212   SP213   SP214   SP215   SP216    SP217   SP218   SP219   SP220   SP221   SP222   SP223   SP224   SP225   SP226   SP227   SP228   SP229   SP230   SP231   SP232   SP233   SP234   SP235   SP236   SP237   SP238   SP239   SP240   SP241   Sp001    Sp004   Sp005   Sp007   Sp008   Sp009   Sp010   Sp011   Sp012   Sp013   Sp014   Sp015   Sp016   Sp017   Sp018   Sp019   Sp020   Sp021   Sp022   Sp023   Sp024   Sp025   Sp026   Sp027   Sp029   Sp030   Sp031    Sp032   Sp034   Sp035   Sp036   Sp037   Sp038   Sp039   Sp040   Sp041   Sp042   Sp043   Sp044   Sp045   Sp046   Sp047   Sp048   Sp049   Sp050   Sp051   Sp053   Sp054   Sp055   Sp056   Sp057   Sp058   Sp059    Sp060   Sp061   Sp062   Sp063   Sp065   Sp066   Sp067   Sp070   Sp071   Sp072   Sp074   Sp077   Sp078   Sp079   Sp082   Sp083   Sp085   Sp087   Sp089   Sp092   Sp093   Sp094   Sp099   Sp100   Sp101   Sp102    Sp103   Sp104   Sp105   Sp106   Sp108   Sp112   Sp113   Sp114   Sp115   Sp116   Sp117   Sp118   Sp119   Sp120   Sp121   Sp122   Sp123   Sp124   Sp125   Sp126   Sp127   Sp129   Sp130   Sp131   Sp132   Sp133    Sp134   Sp135   Sp136   Sp137
#ChrS01  776     .       C       G       166099  PASS    AC=419;AF=0.923;AN=454;AS_BaseQRankSum=-0.700;AS_FS=1.668;AS_InbreedingCoeff=0.5181;AS_MQ=46.16;AS_MQRankSum=-0.600;AS_QD=27.23;AS_ReadPosRankSum=0.400;AS_SOR=0.652;BaseQRankSum=0.00;DP=4548;ExcessHet=0.0000;FS=0.000;InbreedingCoeff=0.5340;MLEAC=437;MLEAF=0.963;MQ=49.67;MQRankSum=-6.010e-01;QD=29.52;ReadPosRankSum=-7.200e-02;SOR=0.642 GT:AD:DP:GQ:PL  0/0:8,0:8:0:0,0,162      0/1:9,5:14:99:176,0,325 1/1:0,4:4:12:136,12,0   1/1:0,7:7:21:296,21,0 

my $out="./$filename.$chr.pseudo_gvcf";
#my @seq=split//,$ref{$chr_iter};

open OUT_VCF, ">$out" || die "$!: Error, cannot open file $out\n";
for my $i (@comments){
	print OUT_VCF "$i\n";
}

for my $site (0..(length($ref{$chr_id})-1)){
	if (exists $vcf_rec{$chr_id}{$site+1}){
		my $tmp=join "\t",@{$vcf_rec{$chr_id}{$site+1}};
		print OUT_VCF "$tmp\n";
	} else {
		my $ref_allele=substr($ref{$chr_id},$site,1);
		my $start=$site+1;
		print OUT_VCF "$chr_id\t$start\tpseudo\t$ref_allele\t$ref_allele\t166099\tPASS\tAC=419;AF=0.923;AN=454;AS_BaseQRankSum=-0.700;AS_FS=1.668;AS_InbreedingCoeff=0.5181;AS_MQ=46.16;AS_MQRankSum=-0.600;AS_QD=27.23;AS_ReadPosRankSum=0.400;AS_SOR=0.652;BaseQRankSum=0.00;DP=4548;ExcessHet=0.0000;FS=0.000;InbreedingCoeff=0.5340;MLEAC=437;MLEAF=0.963;MQ=49.67;MQRankSum=-6.010e-01;QD=29.52;ReadPosRankSum=-7.200e-02;SOR=0.642\tGT:AD:DP:GQ:PL";
		for my $i (0..(@smp-10)){
			print OUT_VCF "\t0/0:13,0:13:36:0,36,540";
		}
		print OUT_VCF "\n";
	}
}
close OUT_VCF;

__END__
module load palma/2020b  GCCcore/10.2.0 Perl/5.32.0
./convert_vcf_2_pseudo.gvcf.pl -v ../ChrS20.vcf  -r /home/wangyz/project/02.duckweed_popg/anno/SP2.0_anno/SP_combined.fasta -c ChrS20
vcf2phylip.py -i ChrS20.vcf.ChrS20.pseudo_gvcf.vcf -f