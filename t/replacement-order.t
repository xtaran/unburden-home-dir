#!perl -l

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('replacement-order');

$t->setup_test_environment_without_target(".foobar/blatest/barba");
$t->write_configs('m d .foo*/bla*/bar* bar%3-bla%2-foo%1');
$t->call_unburden_home_dir_default;

dir_exists_ok( $t->TP."-barba-blatest-foobar" );
file_is_symlink_ok( $t->HOME."/.foobar/blatest/barba" );
symlink_target_is( $t->HOME."/.foobar/blatest/barba",
                   $t->TP."-barba-blatest-foobar" );

$t->done;
