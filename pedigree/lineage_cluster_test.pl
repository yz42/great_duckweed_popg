#! /usr/bin/perl

use strict;
use warnings;
use Array::Utils qw(:all);

my @a = ([1,2],[2,3],[3,4],[5,6],[7,8],[1,9],[4,"a"]);
print "@{$a[0]}\n";
my @b = qw( c d e f );

my @res=lineage_cluster(\@a);
for my $i (0..$#res){
	my @t=@{$res[$i]};
	print @t,"\n";
}


sub lineage_cluster{
	my @in=@{$_[0]};
	# print "@in\n";
	# print "@{$in[0]}\n";
	my @res;
	while (@in>0){

		A: while (1>0){
			my $sw=0;
			@in = grep defined, @in;
			for my $i (1..$#in){
				if (intersect(@{$in[0]}, @{$in[$i]})){
					push @{$in[0]}, @{$in[$i]};
					@{$in[0]}=unique@{$in[0]};
					delete $in[$i];
					$sw++;
				}
			}
			last A if $sw==0;
		}
		push @res, shift @in;
	}
	return @res;
}
