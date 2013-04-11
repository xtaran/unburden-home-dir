#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('check-symlinks-without-trailing-slash');

$t->setup_test_environment_without_target(".foobar");

file_not_exists_ok( $t->TARGET."/fnord" );

ok( symlink($t->TARGET."/u-foobar-fnord", $t->HOME."/.foobar/fnord"), "Create test environment (Symlink)" );
file_is_symlink_ok( $t->HOME."/.foobar/fnord" );

$t->write_configs("m d .foobar/fnord foobar-fnord/\n");

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning;

my $stderr = read_file($t->BASE."/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

$wanted =
    "Create ".$t->TARGET."/u-foobar-fnord\n" .
    "mkdir ".$t->TARGET."\n" .
    "mkdir ".$t->TARGET."/u-foobar-fnord\n";

my $output = read_file($t->BASE."/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

dir_exists_ok( $t->TARGET."/u-foobar-fnord" );

$t->done;
