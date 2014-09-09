#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new;

$t->setup_test_environment('');

file_not_exists_ok( $t->TP."-foobar-fnord" );

$t->write_configs("r F .foobar/fnord foobar-fnord");

$t->call_unburden_home_dir_default('-n');

$t->eq_lsof_warning_or_diff_stderr;

my $wanted = "Touching ".$t->TP."-foobar-fnord
Create parent directories for ".$t->HOME."/.foobar/fnord
Symlinking ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
";
$t->eq_or_diff_stdout($wanted);

file_not_exists_ok( $t->TP."-foobar-fnord" );
file_not_exists_ok( $t->HOME."/.foobar" );

$t->done();

