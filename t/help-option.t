#!perl

use strict;
use warnings;

use Test::More;
use File::Basename;
use 5.010;

my $basedir = $ENV{ADTTMP} ? '/usr' : dirname($0).'/..';
my $dashdash_help = `perl $basedir/bin/unburden-home-dir --help`;
is( $?, 0, 'unburden-home-dir --help exited with 0');

ok( $dashdash_help =~ /Options/, 'unburden-home-dir --help explains options' );
ok( $dashdash_help =~ /Usage/,   'unburden-home-dir --help explains usage' );

my $dash_h = `perl $basedir/bin/unburden-home-dir -h`;
is( $?, 0, 'unburden-home-dir -h exited with 0');

ok( $dash_h =~ /Options/, 'unburden-home-dir -h explains options' );
ok( $dash_h =~ /Usage/,   'unburden-home-dir -h explains usage' );

is( $dash_h, $dashdash_help, 'unburden-home-dir options -h and --help output the same text');

done_testing;
