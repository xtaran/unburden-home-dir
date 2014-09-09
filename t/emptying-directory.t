#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new;

$t->setup_test_environment(".foobar/fnord");
$t->write_configs('d d .foobar foobar');

$t->call_unburden_home_dir_default;

dir_exists_ok( $t->TP."-foobar" );
ok( ! -e $t->TP."-foobar/fnord",
    'Directory '.$t->TP.'-foobar/fnord does not exist' );

$t->done;
