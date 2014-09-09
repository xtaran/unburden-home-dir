#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new;

$t->setup_test_environment(".foobar/blatest");

ok( mkpath($t->TP."-barba-blatest-foobar", {}), "Create test environment (directory)" );
ok( symlink($t->TP."-fnord-blatest-barba", $t->HOME."/.foobar/blatest/barba"), "Create test environment (symlink)" );
file_is_symlink_ok( $t->HOME."/.foobar/blatest/barba" );
ok( write_file($t->TP.'-fnord-blatest-barba', "Some target contents\n"),
    'Create '.$t->TP.'-fnord-blatest-barba with some contents');

$t->write_configs('m d .foobar/blatest/barba foobar-blatest-barba');
$t->call_unburden_home_dir_default('-u');

$t->eq_or_diff_stdout("Trying to revert ".$t->TP."-foobar-blatest-barba to ".
                      $t->HOME."/.foobar/blatest/barba\n");
$t->eq_or_diff_stderr("Ignoring symlink ".$t->HOME."/.foobar/blatest/barba ".
                      "as it points to ".$t->TP."-fnord-blatest-barba and ".
                      "not to ".$t->TP."-foobar-blatest-barba as expected.\n");

dir_exists_ok( $t->TARGET, "Base directory still exists" );
file_exists_ok( $t->TP."-fnord-blatest-barba" );
file_is_symlink_ok( $t->HOME."/.foobar/blatest/barba" );

$t->done;
