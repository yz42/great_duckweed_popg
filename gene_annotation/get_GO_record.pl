#! /usr/bin/perl

use warnings;
use strict;
#use List::MoreUtils ':all';

die "file? perl $0 gff\nThis script is used for extract GO terms from each gene record. (maker + interproscan output)" if (@ARGV==0);

my $in=shift;
open GFF, "<$in";

# ChrS01  maker   gene    19210   20544   .       -       .       ID=SpGA2022_002182;Name=1:g4006;score=0.7;Note=Similar to At2g30270: Protein LURP-one-related 7 (Arabidopsis thaliana);Dbxref=Gene3D:G3DSA:3.20.90.20,InterPro:-,InterPro:IPR007612,InterPro:IPR025659,InterPro:IPR038595,PANTHER:PTHR31087,PANTHER:PTHR31087:SF85,Pfam:PF04525,SUPERFAMILY:SSF54518;_IPRDate=09-03-2022;
# ChrS01  maker   mRNA    19210   20544   .       -       .       ID=SpGA2022_002182-R0;Parent=SpGA2022_002182;Name=1:g4006.t1;_AED=0.45;_QI=0|0.25|0|0.8|0.25|0.4|5|0|157;_eAED=0.45;score=0.34;Note=Similar to At2g30270: Protein LURP-one-related 7 (Arabidopsis thaliana);Dbxref=Gene3D:G3DSA:3.20.90.20,InterPro:-,InterPro:IPR007612,InterPro:IPR025659,InterPro:IPR038595,PANTHER:PTHR31087,PANTHER:PTHR31087:SF85,Pfam:PF04525,SUPERFAMILY:SSF54518;_IPRDate=09-03-2022;
# ChrS01  maker   CDS     19210   19335   .       -       0       ID=SpGA2022_002182-R0:cds;Parent=SpGA2022_002182-R0
# ChrS01  maker   exon    19636   19699   .       -       .       ID=SpGA2022_002182-R0:2;Parent=SpGA2022_002182-R0
# ChrS01  maker   CDS     19636   19699   .       -       1       ID=SpGA2022_002182-R0:cds;Parent=SpGA2022_002182-R0
# ChrS01  maker   mRNA    19210   20544   .       -       .       ID=SpGA2022_002182-R1;Parent=SpGA2022_002182;Name=1:g4006.t2;_AED=0.40;_QI=0|0.66|0|1|0.66|0.5|4|0|162;_eAED=0.40;score=0.36;Note=Similar to At2g30270: Protein LURP-one-related 7 (Arabidopsis thaliana);Dbxref=Gene3D:G3DSA:3.20.90.20,InterPro:-,InterPro:IPR007612,InterPro:IPR025659,InterPro:IPR038595,PANTHER:PTHR31087,PANTHER:PTHR31087:SF85,Pfam:PF04525,SUPERFAMILY:SSF54518;_IPRDate=09-03-2022;
# ChrS01  maker   exon    19210   19335   .       -       .       ID=SpGA2022_002182-R0:1;Parent=SpGA2022_002182-R0,SpGA2022_002182-R1
# ChrS01  maker   CDS     19210   19335   .       -       0       ID=SpGA2022_002182-R1:cds;Parent=SpGA2022_002182-R1
# ChrS01  maker   exon    19636   19677   .       -       .       ID=SpGA2022_002182-R1:6;Parent=SpGA2022_002182-R1
# ###
# ChrS01  maker   gene    26871   46145   .       +       .       ID=SpGA2022_002183;Name=SpGA2022_002183;Alias=maker-ChrS01-snap-gene-0.219;Note=Similar to ddl: D-alanine--D-alanine ligase (Carboxydothermus hydrogenoformans (strain ATCC BAA-161 / DSM 6008 / Z-2901));Dbxref=Gene3D:G3DSA:3.30.470.20,Gene3D:G3DSA:3.40.50.20,InterPro:-,InterPro:IPR011095,InterPro:IPR011127,InterPro:IPR011761,InterPro:IPR016185,PANTHER:PTHR23132,PANTHER:PTHR23132:SF22,Pfam:PF01820,Pfam:PF07478,ProSiteProfiles:PS50975,SUPERFAMILY:SSF52440,SUPERFAMILY:SSF56059;Ontology_term=GO:0005524,GO:0008716,GO:0046872;_IPRDate=09-03-2022;
# ChrS01  maker   mRNA    26871   46145   .       +       .       ID=SpGA2022_002183-R0;Parent=SpGA2022_002183;Name=SpGA2022_002183-R0;Alias=maker-ChrS01-snap-gene-0.219-mRNA-1;_AED=0.39;_QI=145|0.95|0.92|1|0.37|0.52|25|0|996;_eAED=0.39;Note=Similar to ddl: D-alanine--D-alanine ligase (Carboxydothermus hydrogenoformans (strain ATCC BAA-161 / DSM 6008 / Z-2901));Dbxref=Gene3D:G3DSA:3.30.470.20,Gene3D:G3DSA:3.40.50.20,InterPro:-,InterPro:IPR011095,InterPro:IPR011127,InterPro:IPR011761,InterPro:IPR016185,PANTHER:PTHR23132,PANTHER:PTHR23132:SF22,Pfam:PF01820,Pfam:PF07478,ProSiteProfiles:PS50975,SUPERFAMILY:SSF52440,SUPERFAMILY:SSF56059;Ontology_term=GO:0005524,GO:0008716,GO:0046872;_IPRDate=09-03-2022;

my %data;
my %data_out;
my %gene_go_count;
while (<GFF>){
	chomp;
	next if (/^#/);
	my @a=split/\t/,$_;
	next unless ($a[2] eq "gene" or $a[2] eq "mRNA" );
	#ID=SpGA2022_002183;
	#Ontology_term=GO:0005524,GO:0008716,GO:0046872;
	my $id;
	if ($a[8]=~/ID=([\w_-]+);/){
		$id=$1;
		$id=~s/\-\w+$//;
	} else {
		die "$_ dose not match\n";
	}
	if ($a[8]=~/Ontology_term=([\w\:\,]+);/){
		if ($a[2] eq "gene"){
			$gene_go_count{"go"}++;
		}
		my @b=split/,/,$1;
		for my $i (@b){
			$data{$a[2]}{$id}{$i}=0;
			#$data_out{$id}{$i}=0;
		}
	} else {
		if ($a[2] eq "gene"){
			$gene_go_count{"no_go"}++;
		}
	}
}

close GFF;

open OUT, ">$in.GO_record.txt";
print OUT "GO\tgene_ID\n";
for my $gene (sort keys %{$data{"gene"}}){
	for my $go (keys %{$data{"gene"}{$gene}}){
		print OUT "$go\t$gene\n";
	}
}
close OUT;

print "gene_no_go:$gene_go_count{'no_go'}\tgene_with_go:$gene_go_count{'go'}\n";
