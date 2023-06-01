#! /usr/bin/perl

use warnings;
use strict;

die "file? perl $0 <parseval.out>\n" if (@ARGV==0);

my $in=shift;
my $tmpdir="$in.tmp";


open IN, "<$in" || die "can't open file $in\n";
open TMP, ">$in.tmp_file" || die "can't open output file $in.tmp\n";
my (%data,$count);
#$count=0;
while (<IN>){
	chomp;
	next if (/^\s*\|\-*\s*$/);
	#next unless (/^\s+\|\s+/ or /^\|\-+\s+Locus/);
	next unless (/^\s+\|\s+/);
	next if (/^\s+\|\s+reference GFF3:/ or /^\s+\|\s+prediction GFF3:/);
	next if (/^\s+\|\s+\d+\s+reference\s+\w+/ or /^\s+\|\s+\d+\s+prediction\s+\w+/ or /^\s+\|\s+.*match reference/ or /^\s+\|\s+.*match prediction/ or /^\s+\|\s+S\w+:/ or /^\s+\|\s+F1/ or /coefficient/ or /^\s+\|\s+No\s+comparisons/);
	$_=~s/^\s+\|\s+//;
	print  TMP "$_\n";

}
close TMP;
close IN;

open TMP, "<$in.tmp_file";
{	
	local $/="reference transcripts:";
	while (<TMP>){
		chomp;
		next if ($_=~/^\s*$/);
		my @a=split/\n/,$_;
		shift @a;
		#my $str=join("\t",@a);
		#print "$str\n";
		my ($pred,$cds);
		for (my $i=0;$i<$#a;$i++){
			if ($a[$i]=~/prediction\s+transcripts:/){
				$pred=$i;
			} elsif ($a[$i]=~/CDS\s+structure\s+comparison/){
				$cds=$i;
			}
		}
		print "pred:$pred\tcds:$cds\n";
		my ($cds_aed_idx,$cds_aed);
		$cds_aed_idx=$cds+1;
		if ($a[$cds_aed_idx]=~/match\s+perfectly!/){
			$cds_aed=0;
		} elsif ($a[$cds_aed_idx]=~/Annotation\sedit\sdistance:\s+([\-\.\d]+)\s*$/){
			$cds_aed=$1;
		} else { 
			die "$a[$cds_aed_idx] not match!\n";
		}

		for (my $i=$pred+1;$i < $cds;$i++){
			for (my $j=0;$j < $pred;$j++){
				$data{$a[$i]}{$a[$j]}=$cds_aed;
			}
		}
	}
}
close TMP;

open OUT, ">$in.cds_aed.out";
for my $i (keys %data){
	for my $j (keys %{$data{$i}}){
		print OUT "$i\t$j\t$data{$i}{$j}\n";
	}
}
close OUT;




__END__
test:
my @a=(a,b,c,d,e,f,g,h,i,j,k);
my $pred=1;
my $cds=3;
print "pred:$pred\tcds:$cds\n";
print "ref:\t";
for (my $i=0;$i < $pred;$i++){
	print "$a[$i],";
}
print "\n";
print "pred:\t";
for (my $i=$pred+1;$i < $cds;$i++){
	print "$a[$i],";
}
print "\n";
$pred=2;
$cds=4;
print "pred:$pred\tcds:$cds\n";
print "ref:\t";
for (my $i=0;$i < $pred;$i++){
	print "$a[$i],";
}
print "\n";
print "pred:\t";
for (my $i=$pred+1;$i < $cds;$i++){
	print "$a[$i],";
}
print "\n";

$pred=1;
$cds=4;
print "pred:$pred\tcds:$cds\n";
print "ref:\t";
for (my $i=0;$i < $pred;$i++){
	print "$a[$i],";
}
print "\n";
print "pred:\t";
for (my $i=$pred+1;$i < $cds;$i++){
	print "$a[$i],";
}
print "\n";


shell: @ /mnt/e/project/02.duckweed_popg/anno/comp_among_SpGA_Sp74_ISO 
./deal_parseval_out.pl comp.SpGA_iso.out 
./deal_parseval_out.pl comp.Sp74_SpGA.out