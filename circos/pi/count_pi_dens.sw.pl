#! /usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;
use File::Basename;

die ("file? perl $0 <chromosome list> <fasta dir> <file dir> <out dir> <win size [100k]> <step size [10k]>\n") if (@ARGV < 4);

my $chr_l = $ARGV[0];
my $fa_dir = $ARGV[1];
my $file_dir = $ARGV[2];
my $outdir= $ARGV[3];
my $win = $ARGV[4] || 100000;
my $step =  $ARGV[5] || 10000;

die "Error: window size and step size pars are not int.\n perl $0 <fasta file> <chromosome list> <file dir> <out dir> <win size [100k]> <step size [10k]>\n" if ($win!~ /^\d+$/ || $step!~ /^\d+$/);

#my($filename,$directories,$suffix)=fileparse($ARGV[0]);

`mkdir -p $outdir`;
#$filename="$outdir/"."$filename";

open CHR, "<$chr_l" or die "cannot open $chr_l\n";
while (<CHR>){
	chomp;
	my $chr=$_;
	my $fa="$fa_dir/$chr.fa";
	print "dealing with $chr ...\n";

	my @index;
	open BED, ">$outdir/$chr.fa.sw$win.step$step.bed";
	my $seqio = Bio::SeqIO->new('-file' => $fa, '-format' => 'fasta');

	while (my $seqobj = $seqio->next_seq) {
		my $id  = $seqobj->display_id;
		my $seq = $seqobj->seq;
		my $len = $seqobj->length;
		my @sw=sliding_windows($len,$win,$step);
		for my $i (0..$#sw){
			my ($start,$end)=@{$sw[$i]};
			$start--;
			push @index, $start;
			print BED "$id\t$start\t$end\n";
			#my $subseq=$seqobj->subseq($start,$end);
			#print "$i\t$subseq\n";
		}
	}
	close BED;

	open SITE_FILE, "<$file_dir/$chr/SNPGenie_Results/site_results.txt" || die "cannot open $file_dir/$chr/SNPGenie_Results/site_results.txt\n";
	

	my %hash;

# file    product site    ref_nt  maj_nt  position_in_codon       overlapping_ORFs        codon_start_site        codon   pi      gdiv    class_vs_ref    class   coverage        A       C       G       T
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669368 C       C       3       0       2669366 GGC     0.0260266049739734       0.0259695290858726      Synonymous      Synonymous      456     0       450     0       6
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669501 G       A       1       0       2669501 GTG     0.47888953152111	0.477839335180055        Nonsynonymous   Nonsynonymous   456     276     0       180     0
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669528 C       C       1       0       2669528 CTG     0.0555137844611529       0.0553920437057558      Synonymous      Synonymous      456     0       443     0       13
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0000900 2669549 G       G       1       0       2669549 GCC     0.0637651821862348       0.063625346260388       Nonsynonymous   Nonsynonymous   456     15      0       441     0
# ChrS01.vcf.AF_corrected.vcf    Spipo23G0001200 2607507 G       G       3       0       2607505 TCG     0.0217370348949297       0.0216893659587567      Synonymous      Synonymous      456     5.00000000000002        0       451     0
# ChrS01.vcf.AF_corrected.vcf    noncoding       179970  T       G       NA      0       NA      NA      0.369144013880856	0.368334487534626       noncoding       noncoding       456     0       0       345     111
# ChrS01.vcf.AF_corrected.vcf    noncoding       179975  C       C       NA      0       NA      NA      0.174744553691922	0.17436134195137        noncoding       noncoding       456     0       412     0       44
	while (<SITE_FILE>){
		chomp;
		next if (/^file\tproduct\tsite/);
		my @a=split/\t/,$_;
		push @{$hash{$a[2]}},($a[9],$a[11]);
	}
	close SITE_FILE;

	open BED_PI, ">$outdir/$chr.Pi_site_res.bed";
	for my $site (sort {$a<=>$b} keys %hash){
		my $tmp=join("\t",@{$hash{$site}});
		my $start=$site-1;
		print BED_PI "$chr\t$start\t$site\t$tmp\n";
	}
	close BED_PI;

	`bedtools intersect -wa -wb -a $outdir/$chr.fa.sw$win.step$step.bed -b $outdir/$chr.Pi_site_res.bed > $outdir/$chr.intersect`; #bedtools v2.27
# ChrS01  440000  540000  ChrS01  446064  446065  0.295623674571043       noncoding
# ChrS01  440000  540000  ChrS01  446246  446247  0.295623674571043       Nonsynonymous
# ChrS01  440000  540000  ChrS01  446275  446276  0.295623674571043       Synonymous
# ChrS01  440000  540000  ChrS01  446342  446343  0.295623674571043       noncoding
	my %pi;

	open ITSCT, "<$outdir/$chr.intersect" || die "cannot open $outdir/$chr.intersect\n";
	while (<ITSCT>){
		chomp;
		my @a=split/\t/,$_;
		$pi{"pi"}{$a[1]}+=$a[6];

		if ($a[-1] eq "Nonsynonymous"){
			$pi{"piN"}{$a[1]}+=$a[6];
		} elsif ($a[-1] eq "Synonymous"){
			$pi{"piS"}{$a[1]}+=$a[6];
		}
	}
	close ITSCT;

	for my $idx (@index){
		$pi{"pi"}{$idx} = 0 if (! exists $pi{"pi"}{$idx});
		$pi{"piN"}{$idx} = 0 if (! exists $pi{"piN"}{$idx});
		$pi{"piS"}{$idx} = 0 if (! exists $pi{"piS"}{$idx});

		$pi{"pi"}{$idx}=$pi{"pi"}{$idx}/$win;

		if ($pi{"piN"}{$idx} == 0 or $pi{"piS"}{$idx} == 0){
			$pi{"piNpiS"}{$idx} =0;
		} else {
			$pi{"piNpiS"}{$idx}=$pi{"piN"}{$idx}/$pi{"piS"}{$idx};
		}
	}

	open PI_CIR_SCATTER, ">$outdir/pi.$chr.fa.sw$win.step$step.cir_scatter";
	open PINPIS_CIR_SCATTER, ">$outdir/piNpiS.$chr.fa.sw$win.step$step.cir_scatter";
	for my $idx (@index){
		my $start=$idx+1+($win/2);
		print PI_CIR_SCATTER "$chr\t$start\t$start\t$pi{'pi'}{$idx}\n";
		print PINPIS_CIR_SCATTER "$chr\t$start\t$start\t$pi{'piNpiS'}{$idx}\n";
	}
	close PI_CIR_SCATTER;
	close PINPIS_CIR_SCATTER;

}




sub sliding_windows{ #sliding_windows($len,$win,$step)
	my $len=$_[0];
	my $win=$_[1];
	my $step=$_[2];
	#print "$len,$win,$step\n";
	die "Error: window size is larger than the sequence length.\n" if ($win > $len);
	my @out;

	for (my $i=0; $i*$step+$win<=$len; $i++){
		my $start=$i*$step+1;
		my $end=$start+$win-1;
		if ($end > $len){
			$end=$len;
		}
		push @out, [$start,$end];
	}
	return @out;
}

__END__
./count_pi_dens.sw.pl /home/wangyz/sciebo/PopulationGenomics_duckweed/circos_plot/pi/SNPgenie.res_cp/chromosomes.txt /home/wangyz/sciebo/PopulationGenomics_duckweed/circos_plot/ref/fa.split_chr  /home/wangyz/sciebo/PopulationGenomics_duckweed/circos_plot/pi/SNPgenie.res_cp pi_out