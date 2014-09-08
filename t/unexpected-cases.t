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

# Unexpected symlink target type: not a directory
$t->write_configs("r d .foobar/hurz foobar-hurz");
ok( symlink($t->TP.'-foobar-hurz', $t->HOME."/.foobar/hurz"), "Create symlink to wrong target" );
ok( write_file($t->TP.'-foobar-hurz', "Some target contents\n"),
    'Create '.$t->TP.'-foobar-hurz with some contents');

$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("ERROR: Can't handle ".$t->TP.'-foobar-hurz: '.
                      'Unexpected type (not a directory) '.
                      'at bin/unburden-home-dir line 210, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# Unexpected symlink target type: not a file
$t->write_configs("r f .foobar/flaaf foobar-flaaf");
ok( symlink($t->TP.'-foobar-flaaf', $t->HOME."/.foobar/flaaf"), "Create symlink to wrong target" );
ok( $t->create_and_check_directory($t->TP.'-foobar-flaaf',
                                   'unexpected target director '.
                                   $t->TP.'-foobar-flaaf') );
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("ERROR: Can't handle ".$t->TP.'-foobar-flaaf: '.
                      'Unexpected type (not a file) '.
                      'at bin/unburden-home-dir line 210, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# Unexpected file type in list file
$t->write_configs("r x .foobar/flaaf foobar-flaaf");
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("Can't parse type 'x', must be 'd', 'D', 'f' or 'F', ".
                      'skipping... at bin/unburden-home-dir line 661, '.
                      '<$list_fh> line 1.'."\n");
$t->eq_or_diff_stdout('');

# Unexpected action type in list file
$t->write_configs("x f .foobar/flaaf foobar-flaaf");
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("Can't parse action 'x', must be 'd', 'r' or 'm', ".
                      'skipping... at bin/unburden-home-dir line 665, '.
                      '<$list_fh> line 1.'."\n");
$t->eq_or_diff_stdout('');

# Incomplete entry list file (case #1)
$t->write_configs("r f .foobar/flaaf");
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("Can't parse 'r f .foobar/flaaf', skipping... ".
                      'at bin/unburden-home-dir line 657, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# Incomplete entry list file (case #2)
$t->write_configs("r f");
$t->call_unburden_home_dir_default;
$t->eq_or_diff_stderr("Can't parse 'r f', skipping... ".
                      'at bin/unburden-home-dir line 657, <$list_fh> line 1.'.
                      "\n");
$t->eq_or_diff_stdout('');

# lsof not found. Needs mockup of File::Which
$t->write_configs('m f .foobar/fnord foobar-fnord');
$t->call_unburden_home_dir_inc_path('t/lib/mockup');
$t->eq_or_diff_stderr("WARNING: lsof not found, not checking for files in use.\n");

$t->done;
