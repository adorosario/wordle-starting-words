#/usr/bin/perl
#
use strict;
use warnings;
use Data::Dumper;

use lib qw(..);
use JSON qw( );
my $json = JSON->new;


my $all_guesses_filename = $ARGV[0] || 'wordle_answers_plus_allowed_guesses.json';
my $only_answers_filename = $ARGV[1] || 'wordle_answers_only.json';

my $dictionary = $json->decode(read_json_file($all_guesses_filename));
my $answers_dictionary = $json->decode(read_json_file($only_answers_filename));

my $coefficients = {
	'G' => 0.2,
	'Y' => 0.05,
	'B' => 0.0384,
};

# Now calculate the score of each GUESS based on the distance between the GUESS and each possible ANSWER
my $word_scores;
my $count = 0; 
foreach my $word (keys % { $dictionary }) {
	next if (length($word) != 5);
	# last if ( $count++ > 100);
	my $guess_total = 0; 
	foreach my $answer (keys % { $answers_dictionary }) {
		$guess_total += getDistanceScore($word, $answer);
	}
	$word_scores->{$word} = $guess_total;
}

foreach my $w (sort { $word_scores->{$b} <=> $word_scores->{$a} } keys %{ $word_scores }) {
	print join("\t", (uc($w), sprintf("%.2f", $word_scores->{$w}))) . "\n";
}
exit;

sub getDistanceScore {
	my ($word, $answer) = @_;
	my @awcharacters = split(//, $word);

	my @aacharacters = split(//, $answer);
	my %hacharacters = map { $_ => 1 }  @aacharacters;

	my $word_score_total = 0;
	for (my $i=0; $i < 5; $i++) {
		my $c = $awcharacters[$i];

		my $ccolor = "B";
		if ( $c eq $aacharacters[$i]) { 
			$ccolor = "G"; 
		} elsif ( $hacharacters{$c} ) {
			$ccolor = "Y"; 
		}
		$word_score_total += $coefficients->{$ccolor};
	}
	return $word_score_total; 
}

sub read_json_file {
	my $filename = shift;
	my $json_text = do {
		open(my $json_fh, "<:encoding(UTF-8)", $filename) or die("Can't open \"$filename\": $!\n");
		local $/;
		<$json_fh>
	};
	return $json_text;
}