#!/usr/bin/perl -wl

use Test::Simple tests => 10;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/undo';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# 1 - 3
ok( mkpath("$HOME/.foobar/blatest", "$TARGET/$PREFIX-barba-blatest-foobar"), "Create test environment (directories)" );
ok( -d "$TARGET", "Target directory has been created" );
ok( symlink("$TARGET/$PREFIX-barba-blatest-foobar", "$HOME/.foobar/blatest/barba"), "Create test environment (symlink)" );

# 4 + 5
ok( write_file("$BASE/list", 'm d .foo*/bla*/bar* bar%3-bla%2-foo%1'), "Create list" );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s"), "Create config" );

# 6
my $cmd = "bin/unburden-home-dir -u -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 7 - 9
ok( -d "$TARGET", "Base directory still exists" );
ok( ! -e "$TARGET/$PREFIX-barba-blatest-foobar", "Directory no more exists" );
ok( -d "$HOME/.foobar/blatest/barba", "Symlink is a directory again" );

# 10
ok( rmtree("$BASE"), "Remove test environment" );
