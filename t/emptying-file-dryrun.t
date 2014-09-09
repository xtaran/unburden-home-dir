#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
use File::Slurp qw(write_file);

$| = 1;

my $t = Test::UBH->new;

$t->setup_test_environment(".foobar");
$t->write_configs('d f .foobar/fnord foobar-fnord');
ok( write_file($t->HOME.'/.foobar/fnord', "Some contents\n"),
    'Create '.$t->HOME.'/.foobar/fnord with some contents');
file_not_empty_ok($t->HOME.'/.foobar/fnord');

$t->call_unburden_home_dir_default('-n');

file_not_empty_ok($t->HOME.'/.foobar/fnord');

$t->done;
