#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;

my $demodir1 = '.foobar/fnord';
my $demofile1 = "$demodir1/bla";
my $demotarget1 = 'foobar-fnord-bla';
my $demodir2 = '.foobar/blafasel';
my $demofile2 = "$demodir2/bla";
my $demotarget2 = 'foobar-blafasel-bla';

foreach my $configtype (qw(write_user_configs write_xdg_configs)) {
    my $t = Test::UBH->new;
    $t->setup_test_environment($demofile1);

    ok( symlink($demodir1, $t->HOME."/.fnord"),
        "Create test environment (Symlink 1; $configtype)" );
    file_is_symlink_ok( $t->HOME."/.fnord" );
    # https://bugs.debian.org/705242 + https://rt.cpan.org/Public/Bug/Display.html?id=84582
    #symlink_target_exists_ok( $t->HOME."/.fnord" );
    ok( symlink("fnord", $t->HOME."/$demodir2"),
        "Create test environment (Symlink 2; $configtype)" );
    file_is_symlink_ok( $t->HOME."/$demodir2" );
    # https://bugs.debian.org/705242 + https://rt.cpan.org/Public/Bug/Display.html?id=84582
    #symlink_target_exists_ok( $t->HOME."/$demodir2" );

    $t->$configtype("m d $demofile1 $demotarget1\n".
                    "m d .fnord/bla fnord-bla\n".
                    "m d $demofile2 $demotarget2\n");

    $t->call_unburden_home_dir_user;

    my $wanted = $t->prepend_lsof_warning(
        "Skipping '".$t->HOME."/.fnord/bla' due to symlink in path: ".$t->HOME."/.fnord\n" .
        "Skipping '".$t->HOME."/$demofile2' due to symlink in path: ".$t->HOME."/$demodir2\n");
    $t->eq_or_diff_stderr($wanted, "STDERR ($configtype)");

    $wanted =
        "Moving ".$t->HOME."/$demofile1 -> ".$t->TP."-$demotarget1\n" .
        "sending incremental file list\n" .
        "created directory ".$t->TP."-$demotarget1\n" .
        "./\n" .
        "Symlinking ".$t->HOME."/$demofile1 -> ".$t->TP."-$demotarget1\n";
    $t->eq_or_diff_stdout($wanted, "STDOUT ($configtype)");

    dir_exists_ok( $t->TP."-$demotarget1",
                   "First directory moved ($configtype)" );
    file_not_exists_ok( $t->TP."-fnord-bla",
                        "Symlink 1 not moved ($configtype)" );
    file_not_exists_ok( $t->TP."-$demotarget2",
                        "Symlink 2 not moved ($configtype)" );
}

done_testing();
