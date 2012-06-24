#!/usr/bin/perl -w

use Test::Simple tests => 13;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/undo';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

# 1 - 4
ok( mkpath("$HOME/.foobar/blatest", "$TARGET/$PREFIX-barba-blatest-foobar", {}), "Create test environment (directories)" );
ok( -d "$TARGET", "Target directory has been created" );
ok( symlink("$TARGET/$PREFIX-barba-blatest-foobar", "$HOME/.foobar/blatest/barba"), "Create test environment (symlink)" );
ok( -l "$HOME/.foobar/blatest/barba", "Symlink has been created" );

# 5 + 6
ok( write_file("$BASE/list", 'm d .foo*/bla*/bar* bar%3-bla%2-foo%1'), "Create list" );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s"), "Create config" );

# 7
my $cmd = "bin/unburden-home-dir -u -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 8
my $wanted = "Trying to revert $TARGET/$PREFIX-barba-blatest-foobar to $HOME/.foobar/blatest/barba
Removing symlink $HOME/.foobar/blatest/barba
Moving $TARGET/$PREFIX-barba-blatest-foobar -> $HOME/.foobar/blatest/barba
sending incremental file list
created directory $HOME/.foobar/blatest/barba
./
";

my $contents = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$contents\n";
ok( $contents eq $wanted, "Check command output" );

# 9
$wanted = '';
unless (which('lsof')) {
    $wanted = "WARNING: lsof not found, not checking for files in use\n".$wanted;
}

my $stderr = read_file("$BASE/stderr");
print "\nSTDERR:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check command STDERR output (should be empty)" );

# 10 - 12
ok( -d "$TARGET", "Base directory still exists" );
ok( ! -e "$TARGET/$PREFIX-barba-blatest-foobar", "Directory no more exists" );
ok( -d "$HOME/.foobar/blatest/barba", "Symlink is a directory again" );

# 13
ok( rmtree("$BASE"), "Remove test environment" );
