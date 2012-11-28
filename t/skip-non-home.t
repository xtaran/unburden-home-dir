#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

my $BASE = 't/skip-non-home';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

foreach my $example (qw(/foobar ../foobar)) {
    # Create test environment
    ok( mkpath("$HOME/foobar", {}), "Create test environment (directories)" );
    ok( -d "$HOME/foobar", "Original directory has been created" );

    ok( ! -d "$BASE/foobar", "$BASE/foobar does not exist (check for safe environment)" );
    ok( ! -d "/foobar", "$BASE/foobar does not exist (check for safe environment)" );

    ok( write_file("$BASE/list", "m d $example foobar") );
    ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

    my $cmd = "bin/unburden-home-dir -C $BASE/config -L $BASE/list > $BASE/output 2> $BASE/stderr";
    ok( system($cmd) == 0, "Call '$cmd'" );

    my $wanted = "$example would be outside of the home directory, skipping...\n";
    unless (which('lsof')) {
        $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
    }

    my $stderr = read_file("$BASE/stderr");
    eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

    my $output = read_file("$BASE/output");
    print "\nSTDOUT:\n\n$output\n";
    eq_or_diff_text( $output, '', "Check command STDOUT (should be empty)" );

    ok( ! -d "$TARGET/$PREFIX-foobar", "Nothing created" );
    ok( ! -d "$TARGET", "Nothing created" );

    ok( ! -d "$BASE/foobar", "$BASE/foobar still does not exist" );
    ok( ! -d "/foobar", "$BASE/foobar still does not exist" );

    ok( rmtree("$BASE"), "Clean up" );
}

done_testing();
