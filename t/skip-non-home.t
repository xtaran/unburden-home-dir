#!/usr/bin/perl -wl

use Test::Simple tests => 10;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/skip-non-home';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

# Create test environment
# 1 + 2
ok( mkpath("$HOME/foobar", {}), "Create test environment (directories)" );
ok( -d "$HOME/foobar", "Original directory has been created" );

# 3 + 4
ok( write_file("$BASE/list", "m d ../foobar foobar") );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

# 5
my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 6
my $wanted = <<EOF;
../foobar would be outside of the home directory, skipping...
EOF
my $stderr = read_file("$BASE/stderr");
print "Want:\n\n$wanted\nGot:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check command STDERR output" );

# 7
my $output = read_file("$BASE/output");
print "\nSTDOUT:\n\n$stderr\n";
ok( $output eq '', "Check command STDOUT (should be empty)" );

# 8 + 9
ok( ! -d "$TARGET/$PREFIX-foobar", "Nothing created" );
ok( ! -d "$TARGET", "Nothing created" );

# 10
ok( rmtree("$BASE"), "Clean up" );
