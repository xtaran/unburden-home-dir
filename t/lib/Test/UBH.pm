# Module to reduce boilerplate code in unburden-home-dir's test suite

package Test::UBH;

require Exporter;
@ISA = qw(Exporter);

use Mouse;

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

our @EXPORT = (qw(mkpath rmtree),
               @Test::More::EXPORT,
               @Test::Differences::EXPORT,
               @File::Slurp::EXPORT,
               @File::Which::EXPORT,
               @Data::Dumper::EXPORT);

foreach my $varname (qw(TESTNAME BASE HOME TARGET BASENAME PREFIX)) {
    has $varname => ( is => 'rw', isa => 'Str' );
}

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    $self->TESTNAME(shift || 'generic-test');
    $self->BASE('t/'.$self->TESTNAME);
    $self->HOME($self->BASE . '/1');
    $self->TARGET($self->BASE .'/2');
    $self->BASENAME("unburden-home-dir_TEST_$$");
    $self->PREFIX('u');

    # Set a debug environment
    $ENV{HOME} = $self->HOME;

    # Clean up possible remainders of aborted tests
    rmtree($self->BASE);

    return $self;
}

sub cleanup {
    my $self = shift;
    ok( rmtree($self->BASE), "Clean up" );
}

sub setup_test_environment {
    my $t = shift;
    my $demodir = shift;
    ok( mkpath($t->HOME."/$demodir", $t->TARGET, {}), "Create test environment (directories)" );
    ok( -d $t->HOME."/$demodir", "Original directory has been created" );
    ok( -d $t->TARGET, "Target directory has been created" );
}

sub default_config {
    my $t = shift;
    return "TARGETDIR=".$t->TARGET."\nFILELAYOUT=".$t->PREFIX."-\%s";
}

sub call_unburden_home_dir {
    my $t = shift;
    my $param = shift;
    my $cmd =
        'bin/unburden-home-dir '.$param.
        ' >'.$t->BASE.'/output 2>'.$t->BASE.'/stderr';
    ok( system($cmd) == 0, "Call '$cmd'" );
}

sub call_unburden_home_dir_user {
    my $t = shift;
    $t->call_unburden_home_dir('-b '.$t->BASENAME)
}

sub call_unburden_home_dir_default {
    my $t = shift;
    $t->call_unburden_home_dir("-C ".$t->BASE."/config -L ".$t->BASE."/list");
}

sub write_configs {
    my $t = shift;
    my ($list, $config) = @_;
    $t->write_config_file('.'.$t->BASENAME.'.list', $list || '',
                          "Write classic list" );
    $t->write_config_file('.'.$t->BASENAME, $config || $t->default_config,
                          "Write classic config" );
}

sub write_xdg_configs {
    my $t = shift;
    my ($list, $config) = @_;
    ok( mkpath($t->HOME.'/.config/'.$t->BASENAME, {}), "Create test environment (XDG directory)" );
    $t->write_config_file('.config/'.$t->BASENAME.'/list', $list || '',
                          "Write XDG list" );
    $t->write_config_file('.config/'.$t->BASENAME.'/config', $config || $t->default_config,
                          "Write XDG config" );
}

sub write_config_file {
    my $t = shift;
    my ($file, $contents, $desc) = @_;
    BAIL_OUT('write_config_file: $file empty') unless $file;
    BAIL_OUT('write_config_file: $contents undefined') unless defined $contents;

    ok( write_file($t->HOME.'/'.$file,
                   $contents),
        $desc || "Write config file $file" );
}

1;

