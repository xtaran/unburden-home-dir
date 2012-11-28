#!/usr/bin/perl -wl

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Copy;
use File::Slurp;
use File::Which;
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

ok( mkpath($HOME, $XSESSIOND, $BINDIR, {}), "Create test environment (directories)" );
ok( -d "$HOME", "Home directory has been created" );
ok( -d "$BINDIR", "Script directory has been created" );
ok( -d "$XSESSIOND", "Xsession.d directory has been created" );

ok( copy( "Xsession.d/$RPSCRIPT", "$XSESSIOND/" ), "Install Xsession.d script" );
ok( write_file("$BINDIR/unburden-home-dir", "#!/bin/sh\necho \$0 called\n"), "Create test script" );
ok( chmod( 0755, "$BINDIR/unburden-home-dir" ), "Set executable bit on testscript" );
ok( write_file("$HOME/.$BASENAME", "UNBURDEN_HOME=yes\n"), "Configure Xsession.d script to run unburden-home-dir" );

$cmd = "/bin/run-parts --list $XSESSIOND > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

$wanted = "";

$stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check run-parts STDERR output" );
ok( unlink("$BASE/stderr"), "Clean output" );

$wanted = "$XSESSIOND/$RPSCRIPT\n";

$output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check run-parts STDOUT" );
ok( unlink("$BASE/output"), "Clean output" );

$cmd = "/bin/sh $XSESSIOND/$RPSCRIPT > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

$wanted = "";

$stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check Xsession.d STDERR output" );
ok( unlink("$BASE/stderr"), "Clean output" );

$wanted = "$BINDIR/unburden-home-dir called\n";

$output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check Xsession.d STDOUT" );
ok( unlink("$BASE/output"), "Clean output" );

ok( write_file("$HOME/.$BASENAME", "UNBURDEN_HOME=no\n"), "Configure Xsession.d script to NOT run unburden-home-dir" );

$cmd = "/bin/sh $XSESSIOND/$RPSCRIPT > $BASE/output 2> $BASE/stderr";
ok( system($cmd) == 0, "Call '$cmd'" );

$wanted = "";

$stderr = read_file("$BASE/stderr");
eq_or_diff_text( $stderr, $wanted, "Check Xsession.d STDERR output" );
ok( unlink("$BASE/stderr"), "Clean output" );

$wanted = "";

$output = read_file("$BASE/output");
eq_or_diff_text( $output, $wanted, "Check Xsession.d STDOUT" );
ok( unlink("$BASE/output"), "Clean output" );

ok( rmtree("$BASE"), "Clean up" );

done_testing();
