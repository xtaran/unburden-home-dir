# Module to reduce boilerplate code in unburden-home-dir's test suite
use strict;

# Boilerplate which exports into main::
use Test::More;
use Test::Differences;
use Test::File '1.30';
use File::Path qw(mkpath);
use File::Slurp;
use Data::Dumper;

package Test::UBH;

use Moo;

# Boilerplate which exports into Test::UBH::
use Test::More;
use Test::Differences;
use Test::File;
use File::Path qw(mkpath rmtree);
use File::Slurp;
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
}

# Calculated attributes based on BASE

sub HOME   { my $t = shift; return $t->BASE . '/1'; }
sub TARGET { my $t = shift; return $t->BASE . '/2'; }
sub TP     { my $t = shift; return $t->TARGET.'/'.$t->PREFIX; }

# Setup routines

sub setup_test_environment {
    my $t = shift;
    $t->setup_test_environment_without_target(@_);
    $t->create_and_check_directory($t->TARGET,
                                   "test environment (target directory = ".
                                   $t->TARGET.")" );
}

sub setup_test_environment_without_target {
    my $t = shift;
    foreach my $dir (@_) {
        $t->create_and_check_directory($t->HOME."/".($dir || ''),
                                       "test environment (home directory = ".
                                       $t->HOME."): ".($dir || '') );
    }
}

sub create_and_check_directory {
    my $t = shift;
    my ($dir, $desc) = @_;
    ok( mkpath($dir, {}), "Create $desc" );
    ok( -d $dir, "$desc has been created" );
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
    my $t   = shift;
    my $ok  = shift;
    my $cmd = shift;
    die 'Assertion: call_unburden_home_dir* needs at least one non-empty parameter'
        unless @_;
    $cmd .= ' '.join(' ', @_);
    if ($ok) {
        $t->call_cmd($cmd);
    } else {
        $t->fail_cmd($cmd);
    }
}

sub call_unburden_home_dir {
    my $t   = shift;
    my $ok  = shift;
    my $bin = $ENV{ADTTMP} ? '/usr/bin/unburden-home-dir' : 'bin/unburden-home-dir';
    my $cmd = "perl $bin";
    $t->call_unburden_home_dir_common($ok, $cmd, @_);
}

sub call_unburden_home_dir_inc_path {
    my $t = shift;
    my $inc_path = shift;
    my $bin = $ENV{ADTTMP} ? '/usr/bin/unburden-home-dir' : 'bin/unburden-home-dir';
    my $cmd = "perl -I$inc_path $bin";
    $t->call_unburden_home_dir_common(1, $cmd, @_, $t->default_parameters);
}

sub call_cmd {
    my $t = shift;
    my $cmd = shift;
    ok( system($cmd . $t->shell_capture) == 0, "Call '$cmd'" );
}

sub fail_cmd {
    my $t = shift;
    my $cmd = shift;
    ok( ! system($cmd . $t->shell_capture) == 0, "'$cmd' fails" );
}

sub call_unburden_home_dir_user {
    my $t = shift;
    $t->call_unburden_home_dir(1, @_, '-b '.$t->BASENAME)
}

sub call_unburden_home_dir_default {
    my $t = shift;
    $t->call_unburden_home_dir(1, @_, $t->default_parameters);
}

sub fail_unburden_home_dir_default {
    my $t = shift;
    $t->call_unburden_home_dir(0, @_, $t->default_parameters);
}

sub default_parameters {
    my $t = shift;
    return "-C ".$t->BASE."/config -c /dev/null -L ".$t->BASE."/list -l /dev/null";
}

sub write_configs {
    my $t = shift;
    my ($list, $config) = @_;
    $t->write_config_file($t->BASE.'/list', $list || '',
                          'Write classic list ('.$t->BASE.'/list)');
    $t->write_config_file($t->BASE.'/config', $config || $t->default_config,
                          'Write classic config ('.$t->BASE.'/config)' );
}

sub write_user_configs {
    my $t = shift;
    my ($list, $config) = @_;
    $t->write_config_file_to_home('.'.$t->BASENAME.'.list', $list || '',
                                  'Write classic list ('.$t->BASE.'/config)' );
    $t->write_config_file_to_home('.'.$t->BASENAME, $config || $t->default_config,
                                  'Write classic config (.'.$t->BASENAME.')' );
}

sub write_xdg_configs {
    my $t = shift;
    my ($list, $config) = @_;
    ok( mkpath($t->HOME.'/.config/'.$t->BASENAME, {}), "Create test environment (XDG directory)" );
    $t->write_config_file_to_home('.config/'.$t->BASENAME.'/list', $list || '',
                                  'Write XDG list (.config/'.$t->BASENAME.'/list)' );
    $t->write_config_file_to_home('.config/'.$t->BASENAME.'/config', $config || $t->default_config,
                                  'Write XDG config (.config/'.$t->BASENAME.'/config)' );
}

sub write_config_file_to_home {
    my $t = shift;
    my $file = shift;
    $t->write_config_file($t->HOME.'/'.$file, @_);
}

sub write_config_file {
    my $t = shift;
    my ($file, $contents, $desc) = @_;
    BAIL_OUT('write_config_file: $file empty') unless $file;
    BAIL_OUT('write_config_file: $contents undefined') unless defined $contents;

    ok( write_file($file, $contents), $desc || "Write config file $file" );
}

sub shell_capture {
    my $t = shift;
    return ' >'.$t->BASE.'/output 2>'.$t->BASE.'/stderr';
}

sub eq_or_diff_stderr {
    my $t = shift;
    my ($wanted, $desc) = @_;
    $t->eq_or_diff_file('stderr', $desc || 'STDERR', $wanted);
}

sub eq_lsof_warning_or_diff_stderr {
    my $t = shift;
    $t->eq_or_diff_stderr($t->prepend_lsof_warning);
}

sub eq_or_diff_stdout {
    my $t = shift;
    my ($wanted, $desc) = @_;
    $t->eq_or_diff_file('output', $desc || 'STDOUT' , $wanted);
}

sub eq_or_diff_file {
    my $t = shift;
    my ($file, $desc, $wanted) = @_;
    $file = $t->BASE."/$file";
    my $output = read_file($file);

    # Filter out lsof warnings caused by systemd
    my $trailing_newline = $output =~ /\n\z/;
    $output = join("\n", grep {
                          !m{lsof: WARNING: can.?.t stat.. \w+ file system} and
                          !m{Output information may be incomplete}
                   } split("\n", $output));
    $output .= "\n" if $trailing_newline and $output ne '';

    my $bin = $ENV{ADTTMP} ? '/usr/bin/unburden-home-dir' : 'bin/unburden-home-dir';
    $output =~ s(at $bin line \d+([,.]))(at unburden-home-dir line <n>$1)g;

    # Somewhere between coreutils 8.13 (until Wheezy/Quantal), and
    # 8.20 (from Jessie/Raring on) the quoting characters in verbose
    # output of mv. changed. $wanted contains the newer style. In case
    # this test runs with older version of coreutils, we change the
    # output to look like the one from the newer versions.
    $output =~ s/\`/\'/g;

    unified_diff;
    eq_or_diff_text( $output, $wanted || '', "Check $desc" );
    ok( unlink($file), "Clean cache file ($desc)" );
}

1;
