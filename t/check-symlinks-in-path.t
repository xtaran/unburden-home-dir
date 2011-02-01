#!/usr/bin/perl -wl

use Test::Simple tests => 16;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/check-symlinks-in-path';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

# 1 - 3
ok( mkpath("$HOME/.foobar/fnord/bla", "$TARGET", {}), "Create test environment (directories)" );
ok( -d "$HOME/.foobar/fnord/bla", "Original directory has been created" );
ok( -d "$TARGET", "Target directory has been created" );

# 4 - 7
ok( symlink("$HOME/.foobar/fnord", "$HOME/.fnord"), "Create test environment (Symlink 1)" );
ok( -l "$HOME/.fnord", "Symlink 1 has been created" );
ok( symlink("fnord", "$HOME/.foobar/blafasel"), "Create test environment (Symlink 2)" );
ok( -l "$HOME/.foobar/blafasel", "Symlink 2 has been created" );

# 8 + 9
ok( write_file("$BASE/list", "m d .foobar/fnord/bla foobar-fnord-bla\nm d .fnord/bla fnord-bla\nm d .foobar/blafasel/bla foobar-blafasel-bla\n") );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

# 10
my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 11
my $wanted = "Skipping '$HOME/.fnord/bla' due to symlink in path: $HOME/.fnord
Skipping '$HOME/.foobar/blafasel/bla' due to symlink in path: $HOME/.foobar/blafasel
";

my $stderr = read_file("$BASE/stderr");
print "Want:\n\n$wanted\nGot:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check command STDERR output" );

# 12
$wanted = "Create directory $TARGET
Moving $HOME/.foobar/fnord/bla -> $TARGET/u-foobar-fnord-bla
sending incremental file list
created directory $TARGET/u-foobar-fnord-bla
./
Symlinking $TARGET/u-foobar-fnord-bla ->  $HOME/.foobar/fnord/bla
";

my $output = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$output\n";
ok( $output eq $wanted, "Check command STDOUT (should be empty)" );

# 13 - 15
ok( -d "$TARGET/$PREFIX-foobar-fnord-bla", "First directory moved" );
ok( ! -e "$TARGET/$PREFIX-fnord-bla", "Symlink 1 not moved" );
ok( ! -e "$TARGET/$PREFIX-foobar-blafasel-bla", "Symlink 2 not moved" );


# 16
ok( rmtree("$BASE"), "Clean up" );
