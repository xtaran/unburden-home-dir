#!/usr/bin/perl -wl

use File::Copy;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('xsession-d');

my $BINDIR = $t->BASE."/bin";
my $XSESSIOND = $t->BASE."/Xsession.d";
my $RPSCRIPT = "95unburden-home-dir";

my ($cmd, $wanted, $output, $stderr);

# Set a debug environment
$ENV{PATH} = $BINDIR;
$ENV{UNBURDEN_BASENAME} = $t->BASENAME;

$t->setup_test_environment_without_target('');

ok( mkpath($XSESSIOND, $BINDIR, {}), "Create test environment (directories)" );
dir_exists_ok( "$BINDIR", "Script directory has been created" );
dir_exists_ok( "$XSESSIOND", "Xsession.d directory has been created" );

ok( copy( "Xsession.d/$RPSCRIPT", "$XSESSIOND/" ), "Install Xsession.d script" );
ok( write_file("$BINDIR/unburden-home-dir", "#!/bin/sh\necho \$0 called\n"), "Create test script" );
ok( chmod( 0755, "$BINDIR/unburden-home-dir" ), "Set executable bit on testscript" );
ok( write_file($t->HOME.'/.'.$t->BASENAME, "UNBURDEN_HOME=yes\n"), "Configure Xsession.d script to run unburden-home-dir" );

$cmd = "/bin/run-parts --list $XSESSIOND" . $t->shell_capture;
ok( system($cmd) == 0, "Call '$cmd'" );

$t->eq_or_diff_stderr('', "run-parts STDERR");

$wanted = "$XSESSIOND/$RPSCRIPT\n";
$t->eq_or_diff_output($wanted, "run-parts STDOUT");

$cmd = "/bin/sh $XSESSIOND/$RPSCRIPT" . $t->shell_capture;
ok( system($cmd) == 0, "Call '$cmd'" );

$t->eq_or_diff_stderr('', "Xsession.d STDERR");

$wanted = "$BINDIR/unburden-home-dir called\n";
$t->eq_or_diff_output($wanted, "Xsession.d STDOUT");

ok( write_file($t->HOME.'/.'.$t->BASENAME, "UNBURDEN_HOME=no\n"), "Configure Xsession.d script to NOT run unburden-home-dir" );

$cmd = "/bin/sh $XSESSIOND/$RPSCRIPT" . $t->shell_capture;
ok( system($cmd) == 0, "Call '$cmd'" );

$t->eq_or_diff_stderr('');
$t->eq_or_diff_output('');

$t->done;
