#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/find-per-user-stuff';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $BASENAME = "unburden-home-dir_TEST_$$";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

ok( mkpath("$HOME/.foobar/fnord/bla", "$TARGET", {}), "Create test environment (directories)" );
ok( -d "$HOME/.foobar/fnord/bla", "Original directory has been created" );
ok( -d "$TARGET", "Target directory has been created" );

ok( symlink("$HOME/.foobar/fnord", "$HOME/.fnord"), "Create test environment (Symlink 1)" );
ok( -l "$HOME/.fnord", "Symlink 1 has been created" );
ok( symlink("fnord", "$HOME/.foobar/blafasel"), "Create test environment (Symlink 2)" );
ok( -l "$HOME/.foobar/blafasel", "Symlink 2 has been created" );

ok( write_file("$HOME/.$BASENAME.list", "m d .foobar/fnord/bla foobar-fnord-bla\nm d .fnord/bla fnord-bla\nm d .foobar/blafasel/bla foobar-blafasel-bla\n") );
ok( write_file("$HOME/.$BASENAME", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

my $cmd = "bin/unburden-home-dir -b $BASENAME > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

my $wanted = "Skipping '$HOME/.fnord/bla' due to symlink in path: $HOME/.fnord
Skipping '$HOME/.foobar/blafasel/bla' due to symlink in path: $HOME/.foobar/blafasel
";
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
}

my $stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

$wanted = "Moving $HOME/.foobar/fnord/bla -> $TARGET/u-foobar-fnord-bla
sending incremental file list
created directory $TARGET/u-foobar-fnord-bla
./
Symlinking $TARGET/u-foobar-fnord-bla ->  $HOME/.foobar/fnord/bla
";

my $output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d "$TARGET/$PREFIX-foobar-fnord-bla", "First directory moved" );
ok( ! -e "$TARGET/$PREFIX-fnord-bla", "Symlink 1 not moved" );
ok( ! -e "$TARGET/$PREFIX-foobar-blafasel-bla", "Symlink 2 not moved" );

ok( rmtree("$BASE"), "Clean up" );

done_testing();
