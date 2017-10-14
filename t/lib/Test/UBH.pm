# Module to reduce boilerplate code in unburden-home-dir's test suite
use strict;

# Note about why using File::Slurper and not Path::Tiny:
#
# * Path::Tiny could replace File::Slurper, File::Path and File::Temp.
# * But File::Path and File::Temp are part of Perl's core,
#   i.e. usually always already installed.
# * For the additionally required functionality, i.e. pure slurp/spew
#   functionality, I prefer the smaller and simpler module, i.e.
#   File::Slurper (24kB unpacked .deb) over Path::Tiny (158kB).
#
# See
# http://blogs.perl.org/users/leon_timmermans/2015/08/fileslurp-is-broken-and-wrong.html
# for some more background on this discussion.

# Boilerplate which exports into main::
use Test::More;
use Test::Differences;
use Test::File '1.30';
use File::Path qw(mkpath);
use Data::Dumper;

package Test::UBH;

use Moo;

# Boilerplate which exports into Test::UBH::
use Test::More;
use Test::Differences;
use Test::File;
use File::Path qw(mkpath rmtree);
use File::Slurper qw(read_text write_text);
use File::Temp;
use File::Which;
use String::Random qw(random_string);
use Data::Dumper;

sub ubh_temp_dir {
    return File::Temp->newdir(DIR => 't');
}

sub ubh_random_string {
    return String::Random->new->randregex('\w{12}');
}

has 'BASE' => ( is => 'ro', default => \&ubh_temp_dir, init_arg => undef );
foreach my $attribute (qw(PREFIX BASENAME)) {
    has $attribute => ( is => 'ro',
                        default => \&ubh_random_string,
                        init_arg => undef );
}

sub BUILD {
    my $t = shift;

    # Set a debug environment
    $ENV{HOME} = $t->HOME;
    $ENV{LANG} = 'C';

    # For testing environment variable expansion inside the
    # configuration file.
    $ENV{PERCENT_S} = '%s';

    # Clean up possible remainders of aborted tests
    rmtree($t->BASE);

    return $t;
}

sub done {
    my $t = shift;
    done_testing();
    return;
}

# Calculated attributes based on BASE

sub HOME   { my $t = shift; return $t->BASE . '/1'; }
sub TARGET { my $t = shift; return $t->BASE . '/2'; }
sub TP     { my $t = shift; return $t->TARGET.'/'.$t->PREFIX; }

# Set some settings depending on being run inside an autopkgtest environment

sub find_ubh_bin {
    return (($ENV{AUTOPKGTEST_TMP} || $ENV{ADTTMP}) ?
            '/usr/bin/unburden-home-dir' : 'bin/unburden-home-dir');

}

# Setup routines

sub setup_test_environment {
    my ($t, @args) = @_;
    $t->setup_test_environment_without_target(@args);
    $t->create_and_check_directory($t->TARGET,
                                   "test environment (target directory = ".
                                   $t->TARGET.")" );
    return;
}

sub setup_test_environment_without_target {
    my ($t, @args) = @_;
    foreach my $dir (@args) {
        $t->create_and_check_directory($t->HOME."/".($dir || ''),
                                       "test environment (home directory = ".
                                       $t->HOME."): ".($dir || '') );
    }
    return;
}

sub create_and_check_directory {
    my ($t, $dir, $desc) = @_;
    ok( mkpath($dir, {}), "Create $desc" );
    ok( -d $dir, "$desc has been created" );
    return;
}

sub default_config {
    my $t = shift;
    return "TARGETDIR=".$t->TARGET."\nFILELAYOUT=".$t->PREFIX.'-${PERCENT_S}';
}

sub prepend_lsof_warning {
    my $t = shift;
    my $wanted = shift || '';

    unless (which('lsof')) {
        $wanted = "WARNING: lsof not found, not checking for files in use.\n".$wanted;
    }

    return $wanted;
}

sub call_unburden_home_dir_common {
    my ($t, $ok, @cmd) = @_;
    die 'Assertion: call_unburden_home_dir* needs at least one non-empty parameter'
        unless @cmd;
    my $cmd = join(' ', @cmd);
    if ($ok) {
        return $t->call_cmd($cmd);
    } else {
        return $t->fail_cmd($cmd);
    }
}

sub call_unburden_home_dir {
    my ($t, $ok, @args) = @_;
    my $bin = find_ubh_bin;
    my $cmd = "perl $bin";
    return $t->call_unburden_home_dir_common($ok, $cmd, @args);
}

sub call_unburden_home_dir_inc_path {
    my ($t, $inc_path, @args) = @_;
    my $bin = find_ubh_bin;
    my $cmd = "perl -I$inc_path $bin";
    return
        $t->call_unburden_home_dir_common(1, $cmd, @args, $t->default_parameters);
}

sub call_cmd {
    my ($t, $cmd) = @_;
    ok( system($cmd . $t->shell_capture) == 0, "Call '$cmd'" );
    return;
}

sub fail_cmd {
    my ($t, $cmd) = @_;
    ok( ! system($cmd . $t->shell_capture) == 0, "'$cmd' fails" );
    return;
}

sub call_unburden_home_dir_user {
    my ($t, @args) = @_;
    return $t->call_unburden_home_dir(1, @args, '-b '.$t->BASENAME)
}

sub call_unburden_home_dir_default {
    my ($t, @args) = @_;
    return $t->call_unburden_home_dir(1, @args, $t->default_parameters);
}

sub fail_unburden_home_dir_default {
    my ($t, @args) = @_;
    return $t->call_unburden_home_dir(0, @args, $t->default_parameters);
}

sub default_parameters {
    my $t = shift;
    return "-C ".$t->BASE."/config -c /dev/null -L ".$t->BASE."/list -l /dev/null";
}

sub write_configs {
    my ($t, $list, $config) = @_;
    $t->write_config_file($t->BASE.'/list', $list || '',
                          'Write classic list ('.$t->BASE.'/list)');
    $t->write_config_file($t->BASE.'/config', $config || $t->default_config,
                          'Write classic config ('.$t->BASE.'/config)' );
    return;
}

sub write_user_configs {
    my ($t, $list, $config) = @_;
    $t->write_config_file_to_home('.'.$t->BASENAME.'.list', $list || '',
                                  'Write classic list ('.$t->BASE.'/config)' );
    $t->write_config_file_to_home('.'.$t->BASENAME, $config || $t->default_config,
                                  'Write classic config (.'.$t->BASENAME.')' );
    return;
}

sub write_xdg_configs {
    my ($t, $list, $config) = @_;
    ok( mkpath($t->HOME.'/.config/'.$t->BASENAME, {}), "Create test environment (XDG directory)" );
    $t->write_config_file_to_home('.config/'.$t->BASENAME.'/list', $list || '',
                                  'Write XDG list (.config/'.$t->BASENAME.'/list)' );
    $t->write_config_file_to_home('.config/'.$t->BASENAME.'/config', $config || $t->default_config,
                                  'Write XDG config (.config/'.$t->BASENAME.'/config)' );
    return;
}

sub write_config_file_to_home {
    my ($t, $file, @args) = @_;
    return $t->write_config_file($t->HOME.'/'.$file, @args);
}

sub write_config_file {
    my ($t, $file, $contents, $desc) = @_;
    BAIL_OUT('write_config_file: $file empty') unless $file;
    BAIL_OUT('write_config_file: $contents undefined') unless defined $contents;

    ok( $t->write_file($file, $contents), $desc || "Config file $file has been written" );
    return;
}

sub shell_capture {
    my $t = shift;
    return ' >'.$t->BASE.'/output 2>'.$t->BASE.'/stderr';
}

sub eq_or_diff_stderr {
    my ($t, $wanted, $desc) = @_;
    return $t->eq_or_diff_file('stderr', $desc || 'STDERR', $wanted);
}

sub eq_lsof_warning_or_diff_stderr {
    my $t = shift;
    return $t->eq_or_diff_stderr($t->prepend_lsof_warning);
}

sub eq_or_diff_stdout {
    my ($t, $wanted, $desc) = @_;
    return $t->eq_or_diff_file('output', $desc || 'STDOUT' , $wanted);
}

sub eq_or_diff_file {
    my ($t, $file, $desc, $wanted) = @_;
    $file = $t->BASE."/$file";
    my $output = read_text($file);

    # Filter out lsof warnings caused by systemd
    my $trailing_newline = $output =~ /\n\z/;
    $output = join("\n", grep {
                           not(m{lsof: WARNING: can.?.t stat.. \w+ file system}) and
                           not(m{Output information may be incomplete})
                   } split("\n", $output));
    $output .= "\n" if $trailing_newline and $output ne '';

    my $bin = find_ubh_bin;
    $output =~ s(at $bin line \d+([,.]))(at unburden-home-dir line <n>$1)g;

    # Somewhere between coreutils 8.13 (until Wheezy/Quantal), and
    # 8.20 (from Jessie/Raring on) the quoting characters in verbose
    # output of "mv" changed. $wanted contains the newer style. In case
    # this test runs with older version of coreutils, we change the
    # output to look like the one from the newer versions.  Depending
    # on locale settings, it might be even some UTF-8 characters
    $output =~ s/[\`\x{2018}-\x{201f}]/\'/g;

    # With coreutils 8.28 or so, "mv" started to emit its output with
    # the word "renamed". Strip that to stay backwards compatible.
    $output =~ s/^renamed //mg;

    unified_diff;
    eq_or_diff_text( $output, $wanted || '', "Check $desc" );
    ok( unlink($file), "Clean cache file ($desc)" );
    return;
}

sub write_file {
    my ($dummy, @args) = @_;
    return eval { write_text(@args); return 1; };
}

1;
