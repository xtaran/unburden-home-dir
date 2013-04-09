#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('find-per-user-stuff');

ok( mkpath($t->HOME."/.foobar/fnord/bla", $t->TARGET, {}), "Create test environment (directories)" );
ok( -d $t->HOME."/.foobar/fnord/bla", "Original directory has been created" );
ok( -d $t->TARGET, "Target directory has been created" );

ok( symlink($t->HOME."/.foobar/fnord", $t->HOME."/.fnord"), "Create test environment (Symlink 1)" );
ok( -l $t->HOME."/.fnord", "Symlink 1 has been created" );
ok( symlink("fnord", $t->HOME."/.foobar/blafasel"), "Create test environment (Symlink 2)" );
ok( -l $t->HOME."/.foobar/blafasel", "Symlink 2 has been created" );

ok( write_file($t->HOME."/.".$t->BASENAME.".list", "m d .foobar/fnord/bla foobar-fnord-bla\nm d .fnord/bla fnord-bla\nm d .foobar/blafasel/bla foobar-blafasel-bla\n") );
ok( write_file($t->HOME."/.".$t->BASENAME,
               "TARGETDIR=".$t->TARGET."\nFILELAYOUT=".$t->PREFIX."-\%s") );

my $cmd = "bin/unburden-home-dir -b ".$t->BASENAME.
    " > ".$t->BASE."/output 2> ".$t->BASE."/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

my $wanted = "Skipping '".$t->HOME."/.fnord/bla' due to symlink in path: ".$t->HOME."/.fnord
Skipping '".$t->HOME."/.foobar/blafasel/bla' due to symlink in path: ".$t->HOME."/.foobar/blafasel
";
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
}

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
