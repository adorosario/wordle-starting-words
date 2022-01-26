#/usr/bin/perl
#
use strict;
use warnings;
use JSON;

my %words;
while(<STDIN>) {
	chomp;
	$words{lc($_)} = 1; 
}
my $json = encode_json \%words;
print "$json\n";
exit;
