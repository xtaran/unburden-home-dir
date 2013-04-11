#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('create-empty-directories');

$t->setup_test_environment('');

file_not_exists_ok( $t->TP."-foobar-fnord" );

$t->write_configs("r D .foobar/fnord foobar-fnord");

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning;

my $stderr = read_file($t->BASE."/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output (should be empty)" );

$wanted = "Create directory ".$t->TP."-foobar-fnord and parents
mkdir ".$t->TP."-foobar-fnord
Create parent directories for ".$t->HOME."/.foobar/fnord
mkdir ".$t->HOME."/.foobar
Symlinking ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
";

my $output = read_file($t->BASE."/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

dir_exists_ok( $t->TP."-foobar-fnord" );
dir_exists_ok( $t->HOME."/.foobar" );
symlink_target_exists_ok( $t->HOME."/.foobar/fnord" );

$t->done();

