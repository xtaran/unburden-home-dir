#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/check-symlinks-without-trailing-slash';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

ok( mkpath("$HOME/.foobar", {}), "Create test environment (directories)" );
ok( ! -d "$TARGET/fnord", "Target directory does not exist" );

ok( symlink("$TARGET/u-foobar-fnord", "$HOME/.foobar/fnord"), "Create test environment (Symlink)" );
ok( -l "$HOME/.foobar/fnord", "Symlink has been created" );

ok( write_file("$BASE/list", "m d .foobar/fnord foobar-fnord/\n") );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

my $wanted = "";
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
}

my $stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

$wanted = "Create $TARGET/u-foobar-fnord
mkdir $TARGET
mkdir $TARGET/u-foobar-fnord
";

my $output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d "$TARGET/u-foobar-fnord", "Directory created" );

ok( rmtree("$BASE"), "Clean up" );

done_testing();
