#!/usr/bin/perl -wl

use Test::Simple tests => 12;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/undo-dryrun';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# 1 - 3
ok( mkpath("$HOME/.foobar/blatest", "$TARGET/$PREFIX-barba-blatest-foobar", {}), "Create test environment (directories)" );
ok( -d "$TARGET", "Target directory has been created" );
ok( symlink("$TARGET/$PREFIX-barba-blatest-foobar", "$HOME/.foobar/blatest/barba"), "Create test environment (symlink)" );

# 4 + 5
ok( write_file("$BASE/list", 'm d .foo*/bla*/bar* bar%3-bla%2-foo%1'), "Create list" );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s"), "Create config" );

# 6
my $cmd = "bin/unburden-home-dir -n -u -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 7
my $wanted = <<EOF;
Trying to revert $TARGET/u-barba-blatest-foobar to $HOME/.foobar/blatest/barba
Removing symlink $HOME/.foobar/blatest/barba
Moving $TARGET/u-barba-blatest-foobar -> $HOME/.foobar/blatest/barba
EOF
my $contents = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$contents\n";
ok( $contents eq $wanted, "Check command output" );

# 8 - 11
ok( -d "$TARGET", "Base directory still exists" );
ok( -d "$TARGET/$PREFIX-barba-blatest-foobar", "Directory still exists" );
ok( -l "$HOME/.foobar/blatest/barba", "Symlink still exists" );
ok( "$TARGET/$PREFIX-barba-blatest-foobar" eq readlink("$HOME/.foobar/blatest/barba"), "Symlink still has right target" );

# 12
ok( rmtree("$BASE"), "Remove test environment" );
