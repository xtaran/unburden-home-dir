#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('check-symlinks-without-trailing-slash');

$t->setup_test_environment_without_target(".foobar");

ok( ! -d $t->TARGET."/fnord", "Target directory does not exist" );

ok( symlink($t->TARGET."/u-foobar-fnord", $t->HOME."/.foobar/fnord"), "Create test environment (Symlink)" );
ok( -l $t->HOME."/.foobar/fnord", "Symlink has been created" );

ok( write_file($t->BASE."/list", "m d .foobar/fnord foobar-fnord/\n") );
ok( write_file($t->BASE."/config", "TARGETDIR=".$t->TARGET."\nFILELAYOUT=".$t->PREFIX."-\%s") );

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning('');

my $stderr = read_file($t->BASE."/stderr");
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output" );

$wanted =
    "Create ".$t->TARGET."/u-foobar-fnord\n" .
    "mkdir ".$t->TARGET."\n" .
    "mkdir ".$t->TARGET."/u-foobar-fnord\n";

my $output = read_file($t->BASE."/output");
eq_or_diff_text( $output, $wanted, "Check command STDOUT" );

ok( -d $t->TARGET."/u-foobar-fnord", "Directory created" );

$t->done;
