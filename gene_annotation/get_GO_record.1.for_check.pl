#! /usr/bin/perl

use warnings;
use strict;
#use List::MoreUtils ':all';

die "file? perl $0 gff itpsc_out\nThis script is used for extract GO terms from each gene record. (maker + interproscan output)" if (@ARGV==0);

my $in=shift;
my $itprsc=shift;

open GFF, "<$in";
my %gff;

while (<GFF>){
######SpGA2022.1
# pseudo0 iso_seq gene    1161    7613    .       -       .       ID=SpGA2022_050000;gene_id=G9763;transcript_id=G9763.1;Note=Similar to PPR4: Pentatricopeptide repeat-containing protein At5g04810%2C chloroplastic (Arabidopsis thaliana);Dbxref=CDD:cd00590,Gene3D:G3DSA:1.25.40.10,Gene3D:G3DSA:3.30.70.330,InterPro:-,InterPro:IPR000504,InterPro:IPR002885,InterPro:IPR011990,InterPro:IPR012677,InterPro:IPR035979,PANTHER:PTHR47939,PANTHER:PTHR47939:SF1,Pfam:PF00076,Pfam:PF01535,Pfam:PF12854,Pfam:PF13041,Pfam:PF13812,ProSiteProfiles:PS50102,ProSiteProfiles:PS51375,SMART:SM00360,SUPERFAMILY:SSF54928,SUPERFAMILY:SSF81901,TIGRFAM:TIGR00756;Ontology_term=GO:0003676,GO:0005515;_IPRDate=09-05-2022;
# pseudo0 iso_seq mRNA    1161    7613    .       -       .       ID=G9763.2;Parent=SpGA2022_050000;gene_id=G9763;transcript_id=G9763.1;Note=Similar to PPR4: Pentatricopeptide repeat-containing protein At5g04810%2C chloroplastic (Arabidopsis thaliana);Dbxref=CDD:cd00590,Gene3D:G3DSA:1.25.40.10,Gene3D:G3DSA:3.30.70.330,InterPro:-,InterPro:IPR000504,InterPro:IPR002885,InterPro:IPR011990,InterPro:IPR012677,InterPro:IPR035979,PANTHER:PTHR47939,PANTHER:PTHR47939:SF1,Pfam:PF00076,Pfam:PF01535,Pfam:PF12854,Pfam:PF13041,Pfam:PF13812,ProSiteProfiles:PS50102,ProSiteProfiles:PS51375,SMART:SM00360,SUPERFAMILY:SSF54928,SUPERFAMILY:SSF81901,TIGRFAM:TIGR00756;Ontology_term=GO:0003676,GO:0005515;_IPRDate=09-05-2022;
# pseudo0 iso_seq exon    1161    1860    .       -       .       ID=nbis-exon-591541;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2
# pseudo0 iso_seq exon    2128    2257    .       -       .       ID=nbis-exon-591542;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2
# pseudo0 iso_seq exon    2972    3267    .       -       .       ID=nbis-exon-591543;Parent=G9763.2;gene_id=G9763;transcript_id=G9763.2
	chomp;
	next if (/^#/);
	my @a=split/\t/,$_;
	next unless ($a[2] eq "mRNA" );

	my $id;
	if ($a[8]=~/ID=([\w_\-\.]+);/){
		$id=$1;
		#$id=~s/\-\w+$//;
	} else {
		die "$_ dose not match\n";
	}
	if ($a[8]=~/Parent=([\w_\-]+);/){
		$gff{$id}=$1;
	} else {
		die "$_ dose not match\n";
	}
}

close GFF;

open ITPRSC, "<$itprsc";
my %go;

while (<ITPRSC>){
	chomp;
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     Gene3D  G3DSA:2.120.10.80       -       26      142     8.5E-14 T       09-05-2022      IPR015915       Kelch-type beta propeller       GO:0005515
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     PANTHER PTHR46093:SF5   ACYL-COA BINDING PROTEIN-LIKE   25      518     1.6E-205        T       09-05-2022      -       -
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     MobiDBLite      mobidb-lite     consensus disorder prediction   494     521     -       T       09-05-2022      -       -
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     MobiDBLite      mobidb-lite     consensus disorder prediction   495     521     -       T       09-05-2022      -       -
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     Pfam    PF13418 Galactose oxidase, central domain       205     245     8.0E-10 T       09-05-2022      -       -
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     Coils   Coil    Coil    408     442     -       T       09-05-2022      -       -
# G9727.2 7a3a29367bd29d5a997b9925bd626df5        521     Gene3D  G3DSA:2.120.10.80       -       143     401     3.3E-26 T       09-05-2022      IPR015915       Kelch-type beta propeller       GO:0005515
	next if (/^#/);
	my @a=split/\t/,$_;
	my $id =$a[0];
	for my $i (@a){
		if ($i=~/(GO\:\w+)/){
			$go{$id}{$1}=0;
		}
	}
}
close ITPRSC;


for my $i (keys %go){
	my $k=$gff{$i};
	for my $j (keys %{$go{$i}}){
		print "$j\t$i\t$k\n";
	}
}