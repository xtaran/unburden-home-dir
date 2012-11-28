#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/create-empty-directories';
my $HOME = "$BASE/home";
my $TARGET = "$BASE/target";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

ok( mkpath("$HOME", "$TARGET", {}), "Create test environment (directories)" );
ok( -d "$HOME", "Original directory has been created" );
ok( -d "$TARGET", "Target directory has been created" );
ok( ! -d "$TARGET/$PREFIX-foobar-fnord", "unburden directory doesn't yet exist" );

ok( write_file("$BASE/list", "r D .foobar/fnord foobar-fnord"), "Create list" );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s"), "Create config" );

my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

my $wanted = "";
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
}

my $stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output (should be empty)" );

$wanted = "Create directory t/create-empty-directories/target/u-foobar-fnord and parents
mkdir t/create-empty-directories/target/u-foobar-fnord
Create parent directories for $HOME/.foobar/fnord
mkdir $HOME/.foobar
Symlinking $HOME/.foobar/fnord -> $TARGET/u-foobar-fnord
";

my $output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d "$TARGET/$PREFIX-foobar-fnord", "Directory has been created" );
ok( -d "$HOME/.foobar", "Parent directory of symlink has been created." );
ok( -l "$HOME/.foobar/fnord", "Symlink has been created." );

ok( rmtree("$BASE"), "Clean up" );

done_testing();
