#!/usr/bin/perl -wl

use Test::Simple tests => 8;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/undo';
my $HOME = "$BASE/1";
my $TARGET = "$BASE/2";
my $PREFIX = "u";

# Set a debug environment
$ENV{HOME} = $HOME;

# 1 + 2
ok( mkpath("$HOME/.foobar/blatest", "$TARGET/$PREFIX-barba-blatest-foobar") );
ok( symlink("$TARGET/$PREFIX-barba-blatest-foobar", "$HOME/.foobar/blatest/barba") );

# 3 + 4
ok( write_file("$BASE/list", 'm d .foo*/bla*/bar* bar%3-bla%2-foo%1') );
ok( write_file("$BASE/config", "TARGETDIR=$TARGET\nFILELAYOUT=$PREFIX-\%s") );

# 5
ok( system(qw(bin/unburden-home-dir -u -C), "$BASE/config", qw(-L), "$BASE/list" ) == 0 );

# 6 + 7
ok( ! -e "$TARGET/$PREFIX-barba-blatest-foobar" );
ok( -d "$HOME/.foobar/blatest/barba" );

# 8
ok( rmtree("$BASE") );
