#!/usr/bin/perl -wl

use Test::Simple tests => 8;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/replacement-order';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# 1
ok( mkpath("$HOME/.foobar/blatest/barba", "$TARGET") );

# 2 + 3
ok( write_file("$BASE/list", 'm d .foo*/bla*/bar* bar%3-bla%2-foo%1') );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

# 4
ok( system(qw(bin/unburden-home-dir -C), "$BASE/config", qw(-L), "$BASE/list" ) == 0 );

# 5 - 7
ok( -d "$TARGET/$PREFIX-barba-blatest-foobar" );
ok( -l "$HOME/.foobar/blatest/barba" );
eq_or_diff_text( "$TARGET/$PREFIX-barba-blatest-foobar",
                 readlink("$HOME/.foobar/blatest/barba"),
                 "Symlink points to expected location." );

# 8
ok( rmtree("$BASE") );
