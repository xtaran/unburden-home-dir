#!/usr/bin/perl -wl

use Test::Simple tests => 15;
use File::Path qw(mkpath rmtree);
use File::Copy;
use File::Slurp;
use Data::Dumper;

my $BASE = 't/xsession-d';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $BINDIR = "$BASE/bin";
my $XSESSIOND = "$BASE/Xsession.d";
my $RPSCRIPT = "95unburden-home-dir";
my $BASENAME = "unburden-home-dir_TEST_$$";

my ($cmd, $wanted, $output, $stderr);

# Set a debug environment
$ENV{HOME} = $HOME;
$ENV{PATH} = $BINDIR;
$ENV{UNBURDEN_BASENAME} = $BASENAME;

# Clean up possible remainders of aborted tests
rmtree("$BASE");

# 1 - 4
ok( mkpath($HOME, $XSESSIOND, $BINDIR, {}), "Create test environment (directories)" );
ok( -d "$HOME", "Home directory has been created" );
ok( -d "$BINDIR", "Script directory has been created" );
ok( -d "$XSESSIOND", "Xsession.d directory has been created" );

# 5 - 8
ok( copy( "Xsession.d/$RPSCRIPT", "$XSESSIOND/" ), "Install Xsession.d script" );
ok( write_file("$BINDIR/unburden-home-dir", "#!/bin/sh\necho \$0 called\n"), "Create test script" );
ok( chmod( 0755, "$BINDIR/unburden-home-dir" ), "Set executable bit on testscript" );
ok( write_file("$HOME/.$BASENAME", "UNBURDEN_HOME=yes\n"), "Configure Xsession.d script to run unburden-home-dir" );

# 9
$cmd = "/bin/run-parts --list $XSESSIOND > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 10
$wanted = "";

$stderr = read_file("$BASE/stderr");
print "Want:\n\n$wanted\nGot:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check run-parts STDERR output" );

# 11
$wanted = "$XSESSIOND/$RPSCRIPT\n";

$output = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$output\n";
ok( $output eq $wanted, "Check run-parts STDOUT" );

# 12
$cmd = "/bin/sh $XSESSIOND/$RPSCRIPT > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

# 13
$wanted = "";

$stderr = read_file("$BASE/stderr");
print "Want:\n\n$wanted\nGot:\n\n$stderr\n";
ok( $stderr eq $wanted, "Check Xsession.d STDERR output" );

# 14
$wanted = "$BINDIR/unburden-home-dir called\n";

$output = read_file("$BASE/output");
print "Want:\n\n$wanted\nGot:\n\n$output\n";
ok( $output eq $wanted, "Check Xsession.d STDOUT" );

# 15
ok( rmtree("$BASE"), "Clean up" );
