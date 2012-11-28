#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/moving-to-existing-subdir';
my $HOME = "$BASE/home";
my $TARGET = "$BASE/target";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;
$ENV{LANG} = 'C';

# Clean up possible remainders of aborted tests
rmtree("$BASE");

ok( mkpath("$HOME/.foobar/fnord", "$HOME/.foobar/gnarz",
           "$TARGET/$PREFIX-foobar-gnarz", {}), "Create test environment (directories)" );
ok( -d "$HOME/.foobar/fnord", "Original directory has been created" );
ok( -d "$TARGET", "Target directory has been created" );

ok( write_file("$HOME/.foobar/fnord/bla", "123\n"), "Create file 1" );
ok( write_file("$HOME/.foobar/gnarz/goo", "456\n"), "Create file 2" );
ok( write_file("$HOME/.foobar/foo", "abc\n"), "Create file 3" );

ok( write_file("$BASE/list", "m d .foobar/fnord foobar-fnord\nm d .foobar/gnarz foobar-gnarz\nm f .foobar/foo foobar-foo\n"), "Create list" );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s"), "Create config" );

my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

my $wanted = "";
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
}

my $stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output (should be empty)" );

$wanted = "Moving $HOME/.foobar/fnord -> $TARGET/u-foobar-fnord
sending incremental file list
created directory $TARGET/u-foobar-fnord
./
bla
Symlinking $TARGET/u-foobar-fnord ->  $HOME/.foobar/fnord
Moving $HOME/.foobar/gnarz -> $TARGET/u-foobar-gnarz
sending incremental file list
goo
Symlinking $TARGET/u-foobar-gnarz ->  $HOME/.foobar/gnarz
Moving $HOME/.foobar/foo -> $TARGET/u-foobar-foo
`$HOME/.foobar/foo' -> `$TARGET/u-foobar-foo'
Symlinking $TARGET/u-foobar-foo ->  $HOME/.foobar/foo
";

my $output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d "$TARGET/$PREFIX-foobar-fnord", "First directory moved" );
ok( -d "$TARGET/$PREFIX-foobar-gnarz", "Second directory moved" );
ok( -f "$TARGET/$PREFIX-foobar-fnord/bla", "File 1 moved" );
ok( -f "$TARGET/$PREFIX-foobar-gnarz/goo", "File 2 moved" );
ok( -f "$TARGET/$PREFIX-foobar-foo", "File 3 moved" );

ok( rmtree("$BASE"), "Clean up" );

done_testing();
