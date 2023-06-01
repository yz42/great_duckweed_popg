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


######SpGA2022.1
# pseudo0 iso_seq gene    1161    7613    .       -       .       ID=SpGA2022_050000;gene_id=G9763;transcript_id=G9763.1;Note=Similar to PPR4: Pentatricopeptide repeat-containing protein At5g04810%2C chloroplastic (Arabidopsis thaliana);Dbxref=CDD:cd00590,Gene3D:G3DSA:1.25.40.10,Gene3D:G3DSA:3.30.70.330,InterPro:-,InterPro:IPR000504,InterPro:IPR002885,InterPro:IPR011990,InterPro:IPR012677,InterPro:IPR035979,PANTHER:PTHR47939,PANTHER:PTHR47939:SF1,Pfam:PF00076,Pfam:PF01535,Pfam:PF12854,Pfam:PF13041,Pfam:PF13812,ProSiteProfiles:PS50102,ProSiteProfiles:PS51375,SMART:SM00360,SUPERFAMILY:SSF54928,SUPERFAMILY:SSF81901,TIGRFAM:TIGR00756;Ontology_term=GO:0003676,GO:0005515;_IPRDate=09-05-2022;
# pseudo0 iso_seq mRNA    1161    7613    .       -       .       ID=G9763.2;Parent=SpGA2022_050000;gene_id=G9763;transcript_id=G9763.1;Note=Similar to PPR4: Pentatricopeptide repeat-containing protein At5g04810%2C chloroplastic (Arabidopsis thaliana);Dbxref=CDD:cd00590,Gene3D:G3DSA:1.25.40.10,Gene3D:G3DSA:3.30.70.330,InterPro:-,InterPro:IPR000504,InterPro:IPR002885,InterPro:IPR011990,InterPro:IPR012677,InterPro:IPR035979,PANTHER:PTHR47939,PANTHER:PTHR47939:SF1,Pfam:PF00076,Pfam:PF01535,Pfam:PF12854,Pfam:PF13041,Pfam:PF13812,ProSiteProfiles:PS50102,ProSiteProfiles:PS51375,SMART:SM00360,SUPERFAMILY:SSF54928,SUPERFAMILY:SSF81901,TIGRFAM:TIGR00756;Ontology_term=GO:0003676,GO:0005515;_IPRDate=09-05-2022;
# pseudo0 iso_seq exon    1161    1860    .       -       .       ID=nbis-exon-591541;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2
# pseudo0 iso_seq exon    2128    2257    .       -       .       ID=nbis-exon-591542;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2
# pseudo0 iso_seq exon    2972    3267    .       -       .       ID=nbis-exon-591543;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2

my %data;
my %gff;
my %data_out;
my %gene_go_count;
my @all_genes;
while (<GFF>){
	chomp;
	next if (/^#/);
	my @a=split/\t/,$_;
	next unless ($a[2] eq "gene" or $a[2] eq "mRNA" );
	#ID=SpGA2022_002183;
	#Ontology_term=GO:0005524,GO:0008716,GO:0046872;
	my ($id,$parent);
	if ($a[2] eq "gene"){
		if ($a[8]=~/ID=([\w_\-\.]+);/){
			$id=$1;
			#$id=~s/\-\w+$//;
		} else {
			die "$_ dose not match\n";
		}
		if ($a[8]=~/Ontology_term=([\w\:\,]+);/){

			$gene_go_count{"go"}++;

			my @b=split/,/,$1;
			for my $i (@b){
				$data{$a[2]}{$id}{$i}=0;
				#$data_out{$id}{$i}=0;
			}
		}
		push @all_genes, $id;
	} elsif ($a[2] eq "mRNA"){
		if ($a[8]=~/ID=([\w_\-\.]+);/){
			$id=$1;
			#$id=~s/\-\w+$//;
		} else {
			die "$_ dose not match\n";
		}

		if ($a[8]=~/Parent=([\w_\-]+);/){
			$parent=$1;
			$gff{$id}=$parent;
		} else {
			die "$_ dose not match\n";
		}
		if ($a[8]=~/Ontology_term=([\w\:\,]+);/){
			if ($a[2] eq "gene"){
				$gene_go_count{"go"}++;
			}
			my @b=split/,/,$1;
			for my $i (@b){
				$data{$a[2]}{$parent}{$i}=0;
				#$data_out{$id}{$i}=0;
			}
		} 
	}
}

close GFF;

open OUT, ">$in.GO_record.txt";
print OUT "GO\tgene_ID\n";
for my $gene (@all_genes){
	if (exists $data{"gene"}{$gene}){
		for my $go (keys %{$data{"gene"}{$gene}}){
			print OUT "$go\t$gene\n";
		}
	}else {
		$gene_go_count{'no_go'}++;
	}
}
close OUT;

print "gene_no_go:$gene_go_count{'no_go'}\tgene_with_go:$gene_go_count{'go'}\n";
