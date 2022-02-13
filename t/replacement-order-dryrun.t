#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;

my $t = Test::UBH->new;

$t->setup_test_environment_without_target(".foobar/blatest/barba");
$t->write_configs('m d .foo*/bla*/bar* bar%3-bla%2-foo%1');
$t->call_unburden_home_dir_default('-n');

my $wanted = "Create parent directories for ".$t->TP."-barba-blatest-foobar
Moving ".$t->HOME."/.foobar/blatest/barba -> ".$t->TP."-barba-blatest-foobar
Symlinking ".$t->HOME."/.foobar/blatest/barba -> ".$t->TP."-barba-blatest-foobar
";

$t->eq_or_diff_stdout($wanted);

file_not_exists_ok( $t->TP."-barba-blatest-foobar" );
ok( ! -l $t->HOME."/.foobar/blatest/barba",
    "File ".$t->HOME."/.foobar/blatest/barba is no symlink" );
dir_exists_ok( $t->HOME."/.foobar/blatest/barba" );

$t->done;
