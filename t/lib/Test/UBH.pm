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

sub done {
    my $self = shift;

    ok( rmtree($self->BASE), "Clean up" );
    done_testing();
}

1;

