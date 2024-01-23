#!/usr/bin/perl

use strict;
use warnings;

# option to specify binmode

use Tie::File;
use Test::More tests => 3;
use Test::More;

use utf8;

open( my $tmpary, '>:encoding(UTF-8)', '44array.txt')
  or die "test unable to open data file $!\n";
my $sisters = qq!1 NAME Anne /Brontë/
1 NAME Charlotte /Brontë/
1 NAME Emily Jane /Brontë/
!;
print $tmpary $sisters;
close $tmpary;

tie my @array, 'Tie::File', '44array.txt', 'binmode' => ':encoding(UTF-8)';
print "$array[1]\n";
$array[1] =~ /\/(Bront\N{LATIN SMALL LETTER E WITH DIAERESIS})\//;
note( 'on some linux distributions terminal screen output may get mashed with 
  legacy encoding, it will be wrong on the screen but correct in file');
is( $1, "Bront\N{LATIN SMALL LETTER E WITH DIAERESIS}",
  "Bront\N{LATIN SMALL LETTER E WITH DIAERESIS} accent character matches codepoint");
$array[2] =~ /(\N{LATIN SMALL LETTER E WITH DIAERESIS})/;
is( ord($1), 235, 'also use ord to confirm the value of the character read as 235');

push @array, ("Rucksäcke");
untie @array;
tie @array, 'Tie::File', '44array.txt', 'binmode' => ':encoding(UTF-8)';
$array[3] =~ /(\N{LATIN SMALL LETTER A WITH DIAERESIS})/;
is( ord($1), 228, 'write Rucksäcke to file and close/reopen to confirm ä is read');
untie @array;

unlink '44array.txt';




