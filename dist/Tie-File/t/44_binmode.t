#!/usr/bin/perl

use strict;
use warnings;

# option to specify binmode

use Tie::File;
use Test::More tests => 3;
# use Test::More;

use Data::Printer;

use utf8;
use Encode qw(decode encode);

open( my $tmpary, '>:encoding(UTF-8)', '44array.txt')
  or die "test unable to open data file $!\n";
my $sisters = qq!1 NAME Anne /Brontë/
1 NAME Charlotte /Brontë/
1 NAME Emily Jane /Brontë/
!;
print $tmpary $sisters;
close $tmpary;

tie my @array, 'Tie::File', '44array.txt', 'binmode' => 'UTF-8';
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

my $tiobj = tie @array, 'Tie::File', '44array.txt', 'binmode' => 'UTF-8';
$array[3] =~ /(\N{LATIN SMALL LETTER A WITH DIAERESIS})/;
is( ord($1), 228, 'write Rucksäcke to file and close/reopen to confirm ä is read');

# SKIP: {
#   skip "This is a test for GH issue 17494 -- writing a record of a different length on UTF8 file runes the file";

# pass ;

# }
# untie @array;

=pod

This is where I'm working on writing unicode data.

Doing some string manipulation and dumping the results.

As I step through this, after $array[1] = long french string, the file gets an i at the start of the following line.

cat 44array.txt in another terminal at the breakpoint following flush.

=cut
# Test for #17494
# replace a line with a longer one and another with a shorter one
# p @array;
# open my $check ,'>', 'check.txt';
# my $cyrillic = "привіт, світ, зок на довший, а інший – на коротший амінити рядrontë";
# $cyrillic =~ s/[^[:print:]]+//g;
# $cyrillic =~ s/\r//g;
# warn "|$cyrillic|";
# my $french = "En 1815, M. Charles-François-Bienvenu Myriel était évêque de Digne. C'était un vieillard d'environ soixante-quinze ans; il occupait le siège de Digne depuis 1806";

# p @array;

$DB::single = 1;
$array[1] = "En 1815, M. Charles-François-Bienvenu Myriel était évêque de Digne. C'était un vieillard d'environ soixante-quinze ans; il occupait le siège de Digne depuis 1806";
$DB::single = 1;
# p @array;
$tiobj->flush;
$DB::single = 1;
$array[2] = "Emily Jane Brontë";
$DB::single = 1;
# p @array;
push @array, "L'empereur, le soir même, demanda au cardinal le nom de ce curé, et quelque temps après M. Myriel fut tout surpris d'apprendre qu'il était nommé évêque de Digne.";
$tiobj->flush;
$DB::single = 1;
undef $tiobj;
untie @array;

# unlink '44array.txt';




