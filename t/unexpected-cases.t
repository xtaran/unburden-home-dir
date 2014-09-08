#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
use File::Slurp qw(write_file);

$| = 1;

my $t = Test::UBH->new('unexpected_cases');

$t->setup_test_environment(".foobar/bla");

# Expected directory is file
$t->write_configs('m d .foobar/fnord foobar-fnord');
ok( write_file($t->HOME.'/.foobar/fnord', "Some contents\n"),
    'Create '.$t->HOME.'/.foobar/fnord with some contents');
file_not_empty_ok($t->HOME.'/.foobar/fnord');
$t->call_unburden_home_dir_default('-F');
$t->eq_or_diff_stderr("ERROR: Can't handle ".$t->HOME.
                      '/.foobar/fnord: Unexpected type (not a directory) '.
                      'at bin/unburden-home-dir line 210, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# Expected file is directory
$t->write_configs('m f .foobar/bla foobar-bla');
$t->call_unburden_home_dir_default('-F');
$t->eq_or_diff_stderr("ERROR: Can't handle ".$t->HOME.
                      '/.foobar/bla: Unexpected type (not a file) '.
                      'at bin/unburden-home-dir line 210, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# Unexpected symlink target
$t->write_configs("r d .foobar/gnarz foobar-gnarz");
ok( symlink("bla", $t->HOME."/.foobar/gnarz"), "Create symlink to wrong target" );
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("WARNING: Can't handle ".$t->HOME.
                      '/.foobar/gnarz: bla not equal '.$t->TP.'-foobar-gnarz '.
                      'at bin/unburden-home-dir line 204, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# lsof not found. Needs mockup of File::Which
$t->write_configs('m f .foobar/fnord foobar-fnord');
$t->call_unburden_home_dir_inc_path('t/lib/mockup');
$t->eq_or_diff_stderr("WARNING: lsof not found, not checking for files in use.\n");

$t->done;
