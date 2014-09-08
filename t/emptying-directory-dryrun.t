#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('emptying-directory-dryrun');

$t->setup_test_environment(".foobar/fnord");
$t->write_configs('d d .foobar foobar');

$t->call_unburden_home_dir_default('-n');

dir_exists_ok($t->HOME."/.foobar/fnord");

$t->done;
