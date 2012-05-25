#!/usr/bin/perl -wl

use Test::Simple tests => 11;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/check-symlinks-without-trailing-slash';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

# 1 - 2
ok( mkpath("$HOME/.foobar", {}), "Create test environment (directories)" );
ok( ! -d "$TARGET/fnord", "Target directory does not exist" );

# 3 - 4
ok( symlink("$TARGET/u-foobar-fnord", "$HOME/.foobar/fnord"), "Create test environment (Symlink)" );
ok( -l "$HOME/.foobar/fnord", "Symlink has been created" );


# 5 - 6
ok( write_file("$BASE/list", "m d .foobar/fnord foobar-fnord/\n") );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

# 7
my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 8
my $wanted = "";

my $stderr = read_file("$BASE/stderr");
print "Want:\n\n$wanted\nGot:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check command STDERR output" );

# 9
$wanted = "Create $TARGET/u-foobar-fnord
mkdir $TARGET
mkdir $TARGET/u-foobar-fnord
";

my $output = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$output\n";
ok( $output eq $wanted, "Check command STDOUT" );

# 10
ok( -d "$TARGET/u-foobar-fnord", "Directory created" );


# 11
ok( rmtree("$BASE"), "Clean up" );
