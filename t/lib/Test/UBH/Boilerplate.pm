# Default Boilerplate for loading a bunch of common modules in the
# test suite

use Test::More;
use Test::Differences;
use File::Path qw(mkpath rmtree);
use File::Slurp;
use File::Which;
use Data::Dumper;

1;
