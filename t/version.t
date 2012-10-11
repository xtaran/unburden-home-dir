#!/usr/bin/perl -wl

use Test::More tests => 1;
use File::Slurp;
use File::Basename;
use 5.010;

my $basedir = dirname($0).'/..';

my $debian_changelog_version = `head -1 $basedir/debian/changelog | awk -F'[ ()]+' '{print \$2}'`;
chomp($debian_changelog_version);
my $script_version = `egrep '^our .VERSION' $basedir/bin/unburden-home-dir`;
eval($script_version);

is( $debian_changelog_version, $VERSION,
    'Version numbers in debian/changelog and bin/unburden-home-dir are the same' );

