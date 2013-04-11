#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('undo-dryrun');

$t->setup_test_environment(".foobar/blatest");

ok( mkpath($t->TP."-barba-blatest-foobar", {}), "Create test environment (directory)" );
ok( symlink($t->TP."-barba-blatest-foobar", $t->HOME."/.foobar/blatest/barba"), "Create test environment (symlink)" );

$t->write_configs('m d .foo*/bla*/bar* bar%3-bla%2-foo%1');
$t->call_unburden_home_dir_default('-n -u');

my $wanted =
    "Trying to revert ".$t->TP."-barba-blatest-foobar to ".$t->HOME."/.foobar/blatest/barba\n" .
    "Removing symlink ".$t->HOME."/.foobar/blatest/barba\n" .
    "Moving ".$t->TP."-barba-blatest-foobar -> ".$t->HOME."/.foobar/blatest/barba\n";
$t->eq_or_diff_output($wanted);

dir_exists_ok( $t->TARGET, "Base directory still exists" );
dir_exists_ok( $t->TP."-barba-blatest-foobar", "Directory still exists" );
file_is_symlink_ok( $t->HOME."/.foobar/blatest/barba", "Symlink still exists" );
symlink_target_is( $t->HOME."/.foobar/blatest/barba",
                   $t->TP."-barba-blatest-foobar" );

$t->done;
