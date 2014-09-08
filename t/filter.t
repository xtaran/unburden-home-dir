#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('filter');

$t->setup_test_environment('');
file_not_exists_ok( $t->TP."-foobar-fnord" );
$t->write_configs("r F .foobar/fnord foobar-fnord\n".
                  "r F .foobar/gnarz foobar-gnarz\n");
$t->call_unburden_home_dir_default(qw(-f fnord));
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
file_not_exists_ok( $t->TP."-foobar-gnarz" );

# Must bailout with broken filter argument
$t->write_configs("r F .foobar/fnord foobar-fnord");
$t->fail_unburden_home_dir_default(qw[-f '(']);
$t->eq_or_diff_stderr("ERROR: Can't handle parameter to -f: ( ".
                      'at bin/unburden-home-dir line 210.'."\n");
$t->done();

