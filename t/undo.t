#!/usr/bin/perl -w

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('undo');

$t->setup_test_environment(".foobar/blatest");

ok( mkpath($t->TP."-barba-blatest-foobar", {}), "Create test environment (directory)" );
ok( symlink($t->TP."-barba-blatest-foobar", $t->HOME."/.foobar/blatest/barba"), "Create test environment (symlink)" );
file_is_symlink_ok( $t->HOME."/.foobar/blatest/barba" );

$t->write_configs('m d .foo*/bla*/bar* bar%3-bla%2-foo%1');
$t->call_unburden_home_dir_default('-u');

my $wanted =
    "Trying to revert ".$t->TP."-barba-blatest-foobar to ".$t->HOME."/.foobar/blatest/barba\n" .
    "Removing symlink ".$t->HOME."/.foobar/blatest/barba\n" .
    "Moving ".$t->TP."-barba-blatest-foobar -> ".$t->HOME."/.foobar/blatest/barba\n" .
    "sending incremental file list\n" .
    "created directory ".$t->HOME."/.foobar/blatest/barba\n" .
    "./\n";

my $contents = read_file($t->BASE."/output");
eq_or_diff_text( $contents, $wanted, "Check command output" );

$wanted = $t->prepend_lsof_warning;

my $stderr = read_file($t->BASE."/stderr");
print "\nSTDERR:\n\n$stderr\n";
eq_or_diff_text( $stderr, $wanted, "Check command STDERR output (should be empty)" );

dir_exists_ok( $t->TARGET, "Base directory still exists" );
file_not_exists_ok( $t->TP."-barba-blatest-foobar", "Directory no more exists" );
dir_exists_ok( $t->HOME."/.foobar/blatest/barba", "Symlink is a directory again" );

$t->done;
