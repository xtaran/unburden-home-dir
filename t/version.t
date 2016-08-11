#!perl

use strict;
use warnings;
use 5.010;

use Test::More;

if ( $ENV{AUTOPKGTEST_TMP} || $ENV{ADTTMP} ) {
    plan( skip_all => "these tests are for release candidate testing" );
}

use File::Basename;

my $basedir = dirname($0).'/..';

my $debian_changelog_version = `head -1 $basedir/debian/changelog | awk -F'[ ()]+' '{print \$2}'`;
chomp($debian_changelog_version);
our $VERSION;
my $script_version = `egrep '^our .VERSION' $basedir/bin/unburden-home-dir`;
eval($script_version);

is( $debian_changelog_version, $VERSION,
    'Version numbers in debian/changelog and bin/unburden-home-dir are the same' );

my $dashdash_version = `perl $basedir/bin/unburden-home-dir --version`;
my $rc = $?;
is( $rc, 0, 'unburden-home-dir --version exited with 0');

$dashdash_version =~ s/^.*?(\S+)\n*$/$1/;
is( $dashdash_version, $VERSION, 'unburden-home-dir --version shows expected version');

done_testing();
