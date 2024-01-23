#!/usr/bin/env perl

use 5.036;
use utf8;
use feature 'unicode_strings';
use Encode qw(decode encode);

=pod
my $french = "En 1815, M. Charles-François-Bienvenu Myriel était évêque de Digne. C'était un vieillard d'environ soixante-quinze ans; il occupait le siège de Digne depuis 1806";
say $french;
say length($french);
my $decoded = encode( 'UTF8', $french);
say length($decoded);
say $french;


my $cyr = "привіт, світ, зок на довший, а інший – на коротший амінити рядrontë";

say $cyr;
say length($cyr);
$decoded = decode( 'UTF8', $cyr);
say $decoded;
# say length($decoded);
# say $cyr;

=cut


my $cyr = "привіт, світ, зок на довший, а інший – на коротший амінити рядrontë";
say length $cyr;

my $encoding='UTF-8';
sub _length {
  my $rec = shift @_;
  if ($encoding) { 
    # warn "$encoding ======" ;
    # warn length( $rec);
    # my $newrec = encode( $encoding, $rec );
    # warn length ($newrec);
    return CORE::length(encode( $encoding, $rec ));
    }
  return CORE::length($rec);
}

say $cyr;
say _length($cyr);


my $recsep = $/;
my $l1 = length $recsep;
my $l2 = CORE::length(encode( $encoding, $recsep ));
say "recsep length length_endoded $l1 $l2";