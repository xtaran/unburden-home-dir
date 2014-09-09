#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
use File::Slurp qw(write_file);

my $t = Test::UBH->new;

$t->setup_test_environment(".foobar/bla");

# Should not swallow trailing blanks in the list file.
$t->write_configs("r f .foobar/flaaf  ");
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("Can't parse 'r f .foobar/flaaf  ', skipping... ".
                      'at bin/unburden-home-dir line 658, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

$t->done;
