#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('create-empty-files');

$t->setup_test_environment('');

file_not_exists_ok( $t->TP."-foobar-fnord" );

$t->write_configs("r F .foobar/fnord foobar-fnord");

$t->call_unburden_home_dir_default;

$t->eq_lsof_warning_or_diff_stderr;

my $wanted = "Touching ".$t->TP."-foobar-fnord
Create parent directories for ".$t->HOME."/.foobar/fnord
mkdir ".$t->HOME."/.foobar
Symlinking ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
";
$t->eq_or_diff_stdout($wanted);

file_exists_ok( $t->TP."-foobar-fnord" );
dir_exists_ok( $t->HOME."/.foobar" );
symlink_target_exists_ok( $t->HOME."/.foobar/fnord" );

$t->done();

