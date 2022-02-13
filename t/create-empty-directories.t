#!perl

use strict;
use warnings;

use lib qw(t/lib lib);
use Test::UBH;
my $t = Test::UBH->new;

$t->setup_test_environment('');

file_not_exists_ok( $t->TP."-foobar-fnord" );

$t->write_configs("r D .foobar/fnord foobar-fnord\n".
                  "r D .Trash trash\n");
mkdir( $t->HOME."/.Trash" );
dir_exists_ok( $t->HOME."/.Trash" );

$t->call_unburden_home_dir_default;

$t->eq_lsof_warning_or_diff_stderr;

my $wanted = "Create directory ".$t->TP."-foobar-fnord and parents
mkdir ".$t->TP."-foobar-fnord
Create parent directories for ".$t->HOME."/.foobar/fnord
mkdir ".$t->HOME."/.foobar
Symlinking ".$t->HOME."/.foobar/fnord -> ".$t->TP."-foobar-fnord
Delete ".$t->HOME."/.Trash
rmdir ".$t->HOME."/.Trash
Create ".$t->TP."-trash
mkdir ".$t->TP."-trash
Symlinking ".$t->HOME."/.Trash -> ".$t->TP."-trash
";
$t->eq_or_diff_stdout($wanted);

dir_exists_ok( $t->TP."-foobar-fnord" );
dir_exists_ok( $t->TP."-trash" );
dir_exists_ok( $t->HOME."/.foobar" );
symlink_target_exists_ok( $t->HOME."/.foobar/fnord" );
symlink_target_exists_ok( $t->HOME."/.Trash" );

$t->done();
