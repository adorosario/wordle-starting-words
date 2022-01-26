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
	'B' => 0.000000512,
};

# First calculate the probability of each character in each position and each color
# Example : P('A', 'G', 1) - Probability of A being Green in Position 1
my @alphabet = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z);
my @colors = qw(G Y B);
my $probabilities = {};
my $probabilities_totals = {};
foreach my $word (keys % { $answers_dictionary }) {
	if (length($word) != 5) {
		print STDERR "SKIPPED" . "\t" . $word . "\n";
		next;
	}
	print STDERR "WORD" . "\t" . $word . "\n";
	my @acharacters = split(//, $word);
	my %hcharacters = map { $_ => 1 }  @acharacters;

	for (my $i=0; $i < 5; $i++) {
		my $c = $acharacters[$i];
		$probabilities->{$c}->{'G'}->{$i} += 1; 
		$probabilities_totals->{'G'}->{$i} += 1; 
		foreach my $oc (keys %hcharacters) {
			next if ( $oc eq $c);
			$probabilities->{$oc}->{'Y'}->{$i} += 1; 
			$probabilities_totals->{'Y'}->{$i} += 1; 
		}
		foreach my $ac (@alphabet) {
			next if ( $hcharacters{$ac} );
			$probabilities->{$ac}->{'B'}->{$i} += 1; 
			$probabilities_totals->{'B'}->{$i} += 1; 
		}		
	}
}

# Now calculate the score of each word based on the global probabilities and coefficients/value of G,Y,B
my $word_scores;
foreach my $word (keys % { $dictionary }) {
	next if (length($word) != 5);
	my @acharacters = split(//, $word);
	my $word_score_total = 0;
	my %hDoneChars;
	for (my $i=0; $i < 5; $i++) {
		my $c = $acharacters[$i];
		next if ($hDoneChars{$c});
		my $word_pos_score = 0;
		foreach my $color (@colors) {
			$word_pos_score += ( get_probability($c,$color,$i) * $coefficients->{$color} );
		}
		$word_score_total += $word_pos_score;
		$hDoneChars{$c} = 1; 
	}
	$word_scores->{$word} = $word_score_total;
}

foreach my $w (sort { $word_scores->{$b} <=> $word_scores->{$a} } keys %{ $word_scores }) {
	print join("\t", (uc($w), $word_scores->{$w})) . "\n";
}
exit;

sub get_probability {
  my ($char, $color, $pos) =  @_;
  return ( $probabilities->{$char}->{$color}->{$pos} / $probabilities_totals->{$color}->{$pos} ) || 0;
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