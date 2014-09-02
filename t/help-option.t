#!perl -wl

use Test::More tests => 3;
use File::Basename;
use 5.010;

my $basedir = dirname($0).'/..';

my $dashdash_help = `$basedir/bin/unburden-home-dir --help`;
my $rc = $?;
is( $rc, 0, 'unburden-home-dir --help exited with 0');

ok( $dashdash_help =~ /Options/, 'unburden-home-dir --help explains options' );
ok( $dashdash_help =~ /Usage/,   'unburden-home-dir --help explains usage' );
