#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('check-symlinks-without-trailing-slash');

$t->setup_test_environment_without_target(".foobar");

file_not_exists_ok( $t->TARGET."/fnord" );

ok( symlink($t->TP."-foobar-fnord", $t->HOME."/.foobar/fnord"), "Create test environment (Symlink)" );
file_is_symlink_ok( $t->HOME."/.foobar/fnord" );

$t->write_configs("m d .foobar/fnord foobar-fnord/\n");

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning;
$t->eq_or_diff_stderr($wanted);

$wanted =
    "Create ".$t->TP."-foobar-fnord\n" .
    "mkdir ".$t->TARGET."\n" .
    "mkdir ".$t->TP."-foobar-fnord\n";
$t->eq_or_diff_output($wanted);

dir_exists_ok( $t->TP."-foobar-fnord" );

$t->done;
