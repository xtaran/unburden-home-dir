#!perl -l

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;

my $t = Test::UBH->new('skip-non-home');

foreach my $example (qw(/foobar ../foobar)) {
    $t->setup_test_environment_without_target("foobar");

    file_not_exists_ok( $t->BASE."/foobar" );
    file_not_exists_ok( "/foobar" );

    $t->write_configs("m d $example foobar");
    $t->call_unburden_home_dir_default;

    my $wanted = $t->prepend_lsof_warning(
        "$example would be outside of the home directory, skipping...\n");
    $t->eq_or_diff_stderr($wanted);
    $t->eq_or_diff_stdout('');

    file_not_exists_ok( $t->TP."-foobar" );
    file_not_exists_ok( $t->TP );

    file_not_exists_ok( $t->BASE."/foobar" );
    file_not_exists_ok( "/foobar" );

    $t->cleanup;
}

done_testing();
