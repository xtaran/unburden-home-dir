#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('check-symlinks-in-path');

$t->setup_test_environment(".foobar/fnord/bla");

ok( symlink($t->HOME."/.foobar/fnord", $t->HOME."/.fnord"), "Create test environment (Symlink 1)" );
ok( -l $t->HOME."/.fnord", "Symlink 1 has been created" );
ok( symlink("fnord", $t->HOME."/.foobar/blafasel"), "Create test environment (Symlink 2)" );
ok( -l $t->HOME."/.foobar/blafasel", "Symlink 2 has been created" );

ok( write_file($t->BASE."/list", "m d .foobar/fnord/bla foobar-fnord-bla\nm d .fnord/bla fnord-bla\nm d .foobar/blafasel/bla foobar-blafasel-bla\n") );
ok( write_file($t->BASE."/config", "TARGETDIR=".$t->TARGET."\nFILELAYOUT=".$t->PREFIX."-\%s") );

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning(
    "Skipping '".$t->HOME."/.fnord/bla' due to symlink in path: ".$t->HOME."/.fnord
Skipping '".$t->HOME."/.foobar/blafasel/bla' due to symlink in path: ".$t->HOME."/.foobar/blafasel
");

my $stderr = read_file($t->BASE."/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

$wanted = "Moving ".$t->HOME."/.foobar/fnord/bla -> ".$t->TARGET."/u-foobar-fnord-bla
sending incremental file list
created directory ".$t->TARGET."/u-foobar-fnord-bla
./
Symlinking ".$t->TARGET."/u-foobar-fnord-bla ->  ".$t->HOME."/.foobar/fnord/bla
";

my $output = read_file($t->BASE."/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d $t->TARGET."/".$t->PREFIX."-foobar-fnord-bla", "First directory moved" );
ok( ! -e $t->TARGET."/".$t->PREFIX."-fnord-bla", "Symlink 1 not moved" );
ok( ! -e $t->TARGET."/".$t->PREFIX."-foobar-blafasel-bla", "Symlink 2 not moved" );

$t->done();
