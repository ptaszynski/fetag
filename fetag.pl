#!/usr/bin/perl -s
# feature tagging on files for svm
use utf8;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

my $input_file = $ARGV[0];
my $class;
if ($input_file=~ m/plus/g){
	$class = '+1';
} elsif ($input_file=~ m/minus/g){
	$class = '-1';
}

my %wordtoindex;
my %wordtovalue;


open(FILE, 'dic.txt') or die "Cannot open!";
@dic = <FILE>;
close FILE;
chomp(@dic);
foreach $dicentry (@dic) {
	utf8::decode($dicentry);
	my @parts = split(/\t/, $dicentry);
	my $index = shift @parts;
	my $occurence = shift @parts;
	my $word = shift @parts;
	$wordtovalue{$word}=1;
	$wordtoindex{$word}=$index;
}


while (<>) {
utf8::decode($_);
my $input = $_;
# $input =~ tr/\!/！/;
# $input =~ tr/\?/？/;
chomp $input;
# $input = lc $input;

my @outputforsvm;
push @outputforsvm, "$class";
my @words = keys %wordtoindex;

foreach my $oneword (@words) {
	my $input2=$input;
	while ($input2=~ m/\Q $oneword \E/) {
		push @outputforsvm, "$wordtoindex{$oneword}".':'."$wordtovalue{$oneword}";
		$input2=~ s/\Q$oneword\E//;
		next;
	}
}

# push @outputforsvm, "\n";
print "@outputforsvm\n";
}

# foreach (@outputforsvm){
# 	print "$_\n";	
# }


# +1 201:1.2 3148:1.8 3983:1 4882:1

__END__