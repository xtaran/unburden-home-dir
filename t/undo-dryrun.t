#!/usr/bin/perl -wl

use Test::Simple tests => 10;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use Data::Dumper;

my $BASE = 't/undo-dryrun';
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
ok( system("bin/unburden-home-dir -n -u -C $BASE/config -L $BASE/list > $BASE/output" ) == 0 );

# 6
my $wanted = <<EOF;
Trying to revert $TARGET/u-barba-blatest-foobar to $HOME/.foobar/blatest/barba
Removing symlink $HOME/.foobar/blatest/barba
Moving $TARGET/u-barba-blatest-foobar -> $HOME/.foobar/blatest/barba
EOF
ok( read_file("$BASE/output") eq $wanted );

# 7 - 9
ok( -d "$TARGET/$PREFIX-barba-blatest-foobar" );
ok( -l "$HOME/.foobar/blatest/barba" );
ok( "$TARGET/$PREFIX-barba-blatest-foobar" eq readlink("$HOME/.foobar/blatest/barba") );

# 10
ok( rmtree("$BASE") );
