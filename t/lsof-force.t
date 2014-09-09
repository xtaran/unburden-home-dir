#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new;

$t->setup_test_environment_without_target(".foobar");
$t->write_configs('m d .foobar foobar');

ok( open(my $fh, '>', $t->HOME.'/.foobar/fnord'),
    'Can open example file '.$t->HOME.'/.foobar/fnord');

$t->call_unburden_home_dir_default('-F');

close($fh);

symlink_target_is( $t->HOME.'/.foobar', $t->TP."-foobar" );
file_exists_ok( $t->TP."-foobar/fnord" );

$t->done;
