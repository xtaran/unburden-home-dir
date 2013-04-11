#!/usr/bin/perl -wl

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new('check-symlinks-in-path');

$t->setup_test_environment(".foobar/fnord/bla");

ok( symlink(".foobar/fnord", $t->HOME."/.fnord"), "Create test environment (Symlink 1)" );
file_is_symlink_ok( $t->HOME."/.fnord" );
# http://bugs.debian.org/705242 + https://rt.cpan.org/Public/Bug/Display.html?id=84582
#symlink_target_exists_ok( $t->HOME."/.fnord" );

ok( symlink("fnord", $t->HOME."/.foobar/blafasel"), "Create test environment (Symlink 2)" );
file_is_symlink_ok( $t->HOME."/.foobar/blafasel" );
# http://bugs.debian.org/705242 + https://rt.cpan.org/Public/Bug/Display.html?id=84582
#symlink_target_exists_ok( $t->HOME."/.foobar/blafasel" );

$t->write_configs("m d .foobar/fnord/bla foobar-fnord-bla\n" .
                  "m d .fnord/bla fnord-bla\n" .
                  "m d .foobar/blafasel/bla foobar-blafasel-bla\n");

$t->call_unburden_home_dir_default;

my $wanted = $t->prepend_lsof_warning(
    "Skipping '".$t->HOME."/.fnord/bla' due to symlink in path: ".$t->HOME."/.fnord
Skipping '".$t->HOME."/.foobar/blafasel/bla' due to symlink in path: ".$t->HOME."/.foobar/blafasel
");

$t->eq_or_diff_stderr($wanted);

$wanted = "Moving ".$t->HOME."/.foobar/fnord/bla -> ".$t->TP."-foobar-fnord-bla
sending incremental file list
created directory ".$t->TP."-foobar-fnord-bla
./
Symlinking ".$t->TP."-foobar-fnord-bla ->  ".$t->HOME."/.foobar/fnord/bla
";

$t->eq_or_diff_output($wanted);

dir_exists_ok( $t->TP."-foobar-fnord-bla", "First directory moved" );
file_not_exists_ok( $t->TP."-fnord-bla", "Symlink 1 not moved" );
file_not_exists_ok( $t->TP."-foobar-blafasel-bla", "Symlink 2 not moved" );

$t->done();
