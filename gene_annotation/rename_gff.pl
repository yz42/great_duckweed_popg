#! /usr/bin/perl

use strict;
use warnings;

die "file? this script is made for change gene ID (gff3 file), but prio to that, a renaming process need to be done using agat renaming script\n" if (@ARGV==0);

my $gff=shift;
open GFF, "<$gff";
open LOG, ">$gff.renamed.log";
#open MAP, ">$gff.renamed.map";
open OUT, ">$gff.renamed.gff3";

my (%gene_mrna,%mrna_exon,%gene_record,%mrna_record,%other_record,$gene_ID,$rna_ID);

while (<GFF>){
	chomp;
	if (/^\#/){
		print OUT "$_\n";
		next;
	}
	my @a=split/\t/,$_;
# pseudo0 iso_seq gene    629396  646489  .       +       .       ID=SpGA2022_050032;Dbxref=CDD:cd14507,InterPro:-,InterPro:IPR010569,InterPro:IPR029021,InterPro:IPR030564,PANTHER:PTHR10807,PANTHER:PTHR10807:SF123,Pfam:PF06602,ProSiteProfiles:PS51339,SUPERFAMILY:SSF52799;Note=Similar to MTM1: Phosphatidylinositol-3-phosphatase myotubularin-1 (Arabidopsis thaliana);_IPRDate=09-05-2022;gene_id=G9826;transcript_id=G9826.10
# pseudo0 iso_seq mRNA    629396  646489  .       +       .       ID=G9826.6;Parent=SpGA2022_050032;Dbxref=CDD:cd14507,InterPro:-,InterPro:IPR010569,InterPro:IPR029021,InterPro:IPR030564,PANTHER:PTHR10807,PANTHER:PTHR10807:SF123,Pfam:PF06602,ProSiteProfiles:PS51339,SUPERFAMILY:SSF52799;Note=Similar to MTM1: Phosphatidylinositol-3-phosphatase myotubularin-1 (Arabidopsis thaliana);_IPRDate=09-05-2022;gene_id=G9826;transcript_id=G9826.10
# pseudo0 iso_seq exon    629396  629556  .       +       .       ID=nbis-exon-594894;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    629705  629773  .       +       .       ID=nbis-exon-594895;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    630557  630631  .       +       .       ID=nbis-exon-594896;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    630946  631017  .       +       .       ID=nbis-exon-594897;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    631349  631421  .       +       .       ID=nbis-exon-594898;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    631520  631586  .       +       .       ID=nbis-exon-594899;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    632727  632776  .       +       .       ID=nbis-exon-594900;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    632985  633274  .       +       .       ID=nbis-exon-594901;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    633455  633528  .       +       .       ID=nbis-exon-594902;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    633618  633681  .       +       .       ID=nbis-exon-594903;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    633848  633913  .       +       .       ID=nbis-exon-594904;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    634097  634196  .       +       .       ID=nbis-exon-594905;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    634287  634400  .       +       .       ID=nbis-exon-594906;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    635689  635858  .       +       .       ID=nbis-exon-594907;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    636917  637001  .       +       .       ID=nbis-exon-594908;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    639099  639320  .       +       .       ID=nbis-exon-594909;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    639861  639920  .       +       .       ID=nbis-exon-594910;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    640012  640076  .       +       .       ID=nbis-exon-594911;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    644864  645143  .       +       .       ID=nbis-exon-594912;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq exon    645522  646489  .       +       .       ID=nbis-exon-594913;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     632735  632776  .       +       0       ID=cds-465759;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     632985  633274  .       +       0       ID=cds-465760;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     633455  633528  .       +       1       ID=cds-465761;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     633618  633681  .       +       2       ID=cds-465762;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     633848  633913  .       +       1       ID=cds-465763;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     634097  634196  .       +       1       ID=cds-465764;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     634287  634400  .       +       0       ID=cds-465765;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     635689  635858  .       +       0       ID=cds-465766;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     636917  637001  .       +       1       ID=cds-465767;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     639099  639320  .       +       0       ID=cds-465768;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     639861  639920  .       +       0       ID=cds-465769;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     640012  640076  .       +       0       ID=cds-465770;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     644864  645143  .       +       1       ID=cds-465771;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq CDS     645522  646040  .       +       0       ID=cds-465772;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  629396  629556  .       +       .       ID=five_prime_utr-136410;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  629705  629773  .       +       .       ID=five_prime_utr-136411;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  630557  630631  .       +       .       ID=five_prime_utr-136412;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  630946  631017  .       +       .       ID=five_prime_utr-136413;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  631349  631421  .       +       .       ID=five_prime_utr-136414;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6
# pseudo0 iso_seq five_prime_UTR  631520  631586  .       +       .       ID=five_prime_utr-136415;Parent=G9826.6;gene_id=G9826;transcript_id=G9826.6

# pseudo0 maker   gene    614359  618146  .       +       .       ID=SpGA2022_000133;Alias=snap_masked-pseudo0-processed-gene-0.480;Dbxref=InterPro:-,InterPro:IPR007700,InterPro:IPR021864,PANTHER:PTHR31371,PANTHER:PTHR31371:SF20,Pfam:PF05003,Pfam:PF11961;Name=SpGA2022_000133;Note=Similar to PSI1: Protein PSK SIMULATOR 1 (Arabidopsis thaliana);Ontology_term=GO:0045927;_IPRDate=09-05-2022
# pseudo0 maker   mRNA    614359  618146  .       +       .       ID=SpGA2022_000133-R0;Parent=SpGA2022_000133;Alias=snap_masked-pseudo0-processed-gene-0.480-mRNA-1;Dbxref=InterPro:-,InterPro:IPR007700,InterPro:IPR021864,PANTHER:PTHR31371,PANTHER:PTHR31371:SF20,Pfam:PF05003,Pfam:PF11961;Name=SpGA2022_000133-R0;Note=Similar to PSI1: Protein PSK SIMULATOR 1 (Arabidopsis thaliana);Ontology_term=GO:0045927;_AED=0.35;_IPRDate=09-05-2022;_QI=330|1|1|1|0|0|2|1167|708;_eAED=0.35;_merge_warning=1
# pseudo0 maker   exon    614359  616957  .       +       .       ID=SpGA2022_000133-R0:1;Parent=SpGA2022_000133-R0
# pseudo0 maker   exon    617122  618146  .       +       .       ID=SpGA2022_000133-R0:2;Parent=SpGA2022_000133-R0
# pseudo0 maker   CDS     614689  616815  .       +       0       ID=SpGA2022_000133-R0:cds;Parent=SpGA2022_000133-R0
# pseudo0 maker   five_prime_UTR  614359  614688  .       +       .       ID=SpGA2022_000133-R0:five_prime_utr;Parent=SpGA2022_000133-R0
# pseudo0 maker   three_prime_UTR 616816  616957  .       +       .       ID=SpGA2022_000133-R0:three_prime_utr;Parent=SpGA2022_000133-R0
# pseudo0 maker   three_prime_UTR 617122  618146  .       +       .       ID=SpGA2022_000133-R0:three_prime_utr;Parent=SpGA2022_000133-R0
	if ($a[2] eq "gene"){
		if ($a[8]=~/ID=(SpGA2022[\w\.\-]+)/){
			my $id=$1;
			#push @gene_order,$id;
			if ($a[8]=~s/(transcript_id=[\w\.\-\:]+\;?)//){
				print LOG "[gene_entry]remove:$id\t$1\n";
			}
			if ($a[8]=~s/(gene_id=[\w\.\-\:]+)/gene_id=$id/){
				print LOG "[gene_entry]replace:gene_id=$id\t$1\n";
			}

			$gene_ID=$id;
		} else {
			die "$_ dose not match SpGA2022xxxx format\n";
		}
	} elsif ($a[2] eq "mRNA"){
		if (exists $gene_mrna{$gene_ID}){
			my $len;
			my @b=@{$gene_mrna{$gene_ID}};
			$len=@b; ###get already exists array number.
			$rna_ID=$gene_ID."-R".$len;
		} else {
			$rna_ID=$gene_ID."-R0";
		}
		push @{$gene_mrna{$gene_ID}}, $rna_ID;
		print LOG "[mRNA_entry]replace:\t";
		if ($a[8]=~s/(ID=[\w\.\-\:]+)/ID=$rna_ID/){
				print LOG "ID=$rna_ID:$1\t";
		}
		if ($a[8]=~s/(transcript_id=[\w\.\-\:]+)/transcript_id=$rna_ID/){
				print LOG "transcript_id=$rna_ID\t$1\t";
		}
		if ($a[8]=~s/(gene_id=[\w\.\-\:]+)/gene_id=$gene_ID/){
				print LOG "gene_id=$gene_ID\t$1\t";
		}
		print LOG "\n";

	} elsif ($a[2] eq "exon" or $a[2] eq "CDS" or $a[2]=~/_prime_UTR/){
		print LOG "[$a[2]"."_entry]replace:\t";
		if ($a[8]=~s/(transcript_id=[\w\.\-\:]+)/transcript_id=$rna_ID/){
				print LOG "transcript_id=$rna_ID\t$1\t";
		}
		if ($a[8]=~s/(gene_id=[\w\.\-\:]+)/gene_id=$gene_ID/){
				print LOG "gene_id=$gene_ID\t$1\t";
		}
		if ($a[8]=~s/(Parent=[\w\.\-\:]+)/Parent=$rna_ID/){
				print LOG "Parent=$rna_ID\t$1\t";
		}
		print LOG "\n";
	}  elsif ($a[2] eq "tRNA"){
		print OUT "$_\n";
		next;
	} else {
		die "entry $_ dose not match 'gene', 'mRNA', 'exon', 'CDS'or '3-5-prime_UTR'\n";
	}
	my $tmp=join("\t",@a);
	print OUT "$tmp\n";
}

close GFF;
close LOG;
close OUT;

__END__
agat_sp_extract_sequences.pl -g SpGA2022.3.gff3 -f /mnt/e/project/02.duckweed_popg/anno/SP2.0_anno/SP_combined.fasta -t cds -p -o SpGA2022.3.protein.fa
