#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
use File::Touch;

my $t = Test::UBH->new;

$t->setup_test_environment(".foobar/fnord", ".foobar/gnarz");
ok( mkpath($t->TP."-foobar-gnarz", {}), 'Create test environment (target)' );

ok( $t->write_file($t->HOME."/.foobar/fnord/bla", "123\n"), "Create file 1" );
ok( $t->write_file($t->HOME."/.foobar/gnarz/goo", "456\n"), "Create file 2" );
ok( $t->write_file($t->HOME."/.foobar/foo", "abc\n"), "Create file 3" );

$t->write_configs("m d .foobar/fnord foobar-fnord\n" .
                  "m d .foobar/gnarz foobar-gnarz\n" .
                  "m f .foobar/foo foobar-foo\n");

# Fixes race condition in rsync
File::Touch->new(mtime => time-60)->touch($t->HOME."/.foobar/gnarz");

$t->call_unburden_home_dir_default;

$t->eq_lsof_warning_or_diff_stderr;

my $wanted = "Moving ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
sending incremental file list
created directory ".$t->TP."-foobar-fnord
./
bla
Symlinking ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
Moving ".$t->HOME."/.foobar/gnarz -> ".$t->TP."-foobar-gnarz
sending incremental file list
./
goo
Symlinking ".$t->HOME."/.foobar/gnarz -> ".$t->TP."-foobar-gnarz
Moving ".$t->HOME."/.foobar/foo -> ".$t->TP."-foobar-foo
'".$t->HOME."/.foobar/foo' -> '".$t->TP."-foobar-foo'
Symlinking ".$t->HOME."/.foobar/foo -> ".$t->TP."-foobar-foo
";
$t->eq_or_diff_stdout($wanted);

dir_exists_ok( $t->TP."-foobar-fnord", "First directory moved" );
dir_exists_ok( $t->TP."-foobar-gnarz", "Second directory moved" );
file_exists_ok( $t->TP."-foobar-fnord/bla", "File 1 moved" );
file_exists_ok( $t->TP."-foobar-gnarz/goo", "File 2 moved" );
file_exists_ok( $t->TP."-foobar-foo", "File 3 moved" );

$t->done;
